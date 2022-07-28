# Athenaの結果確認をDigdagのretryで行ってみた

エンドポイントなどのCloudFormationテンプレートと、Digdagに設定するdigファイルなどを以下のGithubレポジトリに格納しました。

適当なEC2がVPCのプライベートサブネットにあり、Digdagがインストールされている前提となります。

## CloudFormation
以下のテンプレートを`cloudformation`ディレクトリに入れています。
- データレイク層およびデータマート層用のS3のテンプレート
- S3およびAthenaへの通信に使用するVPCエンドポイントのテンプレート
- AWS Systems Manager Session Managerでの通信に使用するVPCエンドポイントのテンプレート

## Athenaのテーブル定義
`ddl`ディレクトリにデータレイク層およびデータマート層用のテーブル定義例を格納しています。
以下は適切なものに修正してください。
- lake.sql
    - データレイク用バケット名
- mart.sql
    - データマート用バケット名

## Digdagプロジェクト
検証に使用したプロジェクトの実装例を`create_mart`ディレクトリに入れています。
以下の構成になっています。

```
create_mart
├── creta_data_mart.dig
├── python
│   └── athena.py
└── sql
    └── sample_mart.sql
```

`creta_data_mart.dig`では、以下を適切なものに修正してください。

- データレイク層用のバケット名
- テーブル定義を作成するデータベース名
- Athena検索結果出力用のバケット名
- Athenaのワークグループ名

また、Pythonは`/usr/bin/python3`にインストールされているものを使う様に記載しています。

## データ作成例
`data_create`ディレクトリに作成に使用したJupyterノートブックの例を格納しています。異なるデータを作成する場合は、`ddl`ディレクトリのDDLとDigdagから実行する`sql/sample_mart.sql`も合わせて修正してください。