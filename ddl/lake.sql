CREATE EXTERNAL TABLE `wine_data` (
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
  `yyyymmdd` string COMMENT '')
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ( 
  'escapeChar'='\\', 
  'quoteChar'='\"', 
  'separatorChar'=',') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://データレイク用バケット名/wine_data'
TBLPROPERTIES (
  'projection.enabled' = 'true',
  'projection.yyyymmdd.type' = 'date',
  'projection.yyyymmdd.range' = '20220401,NOW+1DAY',
  'projection.yyyymmdd.format' = 'yyyyMMdd',
  'projection.yyyymmdd.interval' = '1',
  'projection.yyyymmdd.interval.unit' = 'DAYS',
  'storage.location.template'='s3://データレイク用バケット名/wine_data/yyyymmdd=${yyyymmdd}',
  'skip.header.line.count'='1', 
  'compressionType'='none', 
  'delimiter'=',', 
  'escapeChar'='\\'
)