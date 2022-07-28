CREATE EXTERNAL TABLE `wine_mart` (
`alcohol` float,
`malic_acid` float,
`ash` float,
`alcalinity_of_ash` float,
`magnesium` float,
`total_phenols` float,
`flavanoids` float,
`nonflavanoid_phenols` float,
`proanthocyanins` float,
`color_intensity` float,
`hue` float,
`od280/od315_of_diluted_wines` float,
`proline` float,
`target` int
)
PARTITIONED BY ( 
  `yyyymmdd` string)
ROW FORMAT SERDE
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://データマート用バケット名/wine_mart'
TBLPROPERTIES (
  'projection.enabled' = 'true',
  'projection.yyyymmdd.type' = 'date',
  'projection.yyyymmdd.range' = '20220401,NOW+1DAY',
  'projection.yyyymmdd.format' = 'yyyyMMdd',
  'projection.yyyymmdd.interval' = '1',
  'projection.yyyymmdd.interval.unit' = 'DAYS',
  'storage.location.template'='s3://データマート用バケット名/wine_mart/yyyymmdd=${yyyymmdd}'
)