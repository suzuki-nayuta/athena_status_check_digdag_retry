INSERT INTO wine_mart
SELECT 
  "alcohol",
  "malic_acid",
  "ash",
  "alcalinity_of_ash",
  "magnesium",
  "total_phenols",
  "flavanoids",
  "nonflavanoid_phenols",
  "proanthocyanins",
  "color_intensity",
  "hue",
  "od280/od315_of_diluted_wines",
  "proline",
  "target",
  '${yyyymmdd}' AS yyyymmdd
FROM wine_data
WHERE yyyymmdd = '${yyyymmdd}'