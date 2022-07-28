import boto3
import digdag


def execute_sql_file(sql_file_path):
    """ 指定したパスのDMLを読み出し、Athenaで実行する。
    """
    param = digdag.env.params
    workgroup = param['workgroup']
    athena_result_key_prefix = param['athena_result_key_prefix']
    database_name = param['database_name']
    athena_client = boto3.client('athena', region_name='ap-northeast-1')
    result_configuration = {"OutputLocation": athena_result_key_prefix}
    query_execution_context = {'Database': database_name}

    with open(sql_file_path, 'r') as sql_f:
        sql = sql_f.read()

    for k, v in list(param.items()):
        sql = sql.replace(f'${{{k}}}', str(v))

    print(sql)

    execution_id = athena_client.start_query_execution(
        QueryString=sql,
        QueryExecutionContext=query_execution_context,
        ResultConfiguration=result_configuration,
        WorkGroup=workgroup

    )["QueryExecutionId"]
    print(f"QueryExecutionId: {execution_id}")
    digdag.env.store({"execution_id": execution_id})


def check_query_status(execution_id):
    """ クエリの実行が終わっているか確認する。終わっていない場合は例外を送出してdigdag側でリトライする。
    """
    param = digdag.env.params
    execution_id = param['execution_id']

    athena_client = boto3.client('athena', region_name='ap-northeast-1')
    status = athena_client.get_query_execution(QueryExecutionId=execution_id)["QueryExecution"]["Status"]
    if status["State"] not in ["SUCCEEDED", "FAILED", "CANCELLED"]:
        raise Exception("Query is running now!")
    else:
        print(f"QueryExecutionId: {execution_id}")
        print(f"Status: {status['State']}")
        is_query_success = (status['State']=="SUCCEEDED")
        digdag.env.store({"is_query_success": is_query_success})
