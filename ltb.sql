WITH cte AS
(
  SELECT
    DIR_ID,
    NAME,
    TYPE,
    PARENT_ID
    --CAST(0 AS varbinary(max)) AS Level
  FROM MATFOLDER
  WHERE PARENT_ID = 19630
  UNION ALL
  SELECT
    i.DIR_ID,
    i.NAME,
    i.TYPE,
    i.PARENT_ID
    --Level + CAST(i.DIR_ID AS varbinary(max)) AS Level
  FROM MATFOLDER i
  INNER JOIN cte c
    ON c.DIR_ID = i.PARENT_ID
)
,
cte2 AS
(
  SELECT
    DIR_ID,
    NAME,
    TYPE,
    PARENT_ID
    --CAST(0 AS varbinary(max)) AS Level
  FROM PROFFOLDER
  WHERE PARENT_ID = 3575
  UNION ALL
  SELECT
    i.DIR_ID,
    i.NAME,
    i.TYPE,
    i.PARENT_ID
    --Level + CAST(i.DIR_ID AS varbinary(max)) AS Level
  FROM PROFFOLDER i
  INNER JOIN cte2 c
    ON c.DIR_ID = i.PARENT_ID
)

SELECT
M.BESTELLUNG AS Symbol,
M.BESTELLUNG AS MatId,
CASE
	WHEN LEN(M.TEXT) - LEN(REPLACE(M.TEXT, 'x', '')) = 1
		THEN
SUBSTRING(M.TEXT,0,CHARINDEX('x',M.TEXT))
ELSE ''
END AS Length,
CASE
	WHEN LEN(M.TEXT) - LEN(REPLACE(M.TEXT, 'x', '')) = 1
		THEN
RIGHT(M.TEXT,CHARINDEX('x',REVERSE(M.TEXT))-1)
ELSE ''
END AS Width,
M.THK AS Thicknes,
0 AS MatType,
M.COMMENT AS Description,
M.MATCAT AS Groups,
M.PRODUCER AS SubGroups,
M.GRAIN AS Grain,
'm2' AS Unit,
CASE
	WHEN LEN(M.TEXT) - LEN(REPLACE(M.TEXT, 'x', '')) = 1
		THEN 1 ELSE 0 END AS FlagActive,
'logo.png' AS Picture,
'logo.png' AS Picture1,
'logo.png' AS Picture2
FROM cte C
LEFT JOIN MAT M ON C.NAME = M.NAME
LEFT JOIN CMSRAWMAT R ON C.NAME = R.MATID
WHERE TYPE = 100 AND M.BESTELLUNG <> ''

UNION

SELECT
P.BESTELLUNG AS Symbol,
P.BESTELLUNG AS MatId,
0 AS Length,
P.THK AS Width,
P.PRFWS AS Thicknes,
11 AS MatType,
P.COMMENT AS Description,
P.PRODUCER AS Groups,
'' AS SubGroups,
0 AS Grain,
'm' AS Unit,
CASE
	WHEN P.THK <> '' AND P.PRFWS <> ''
		THEN 1 ELSE 0 END AS FlagActive,
'logo.png' AS Picture,
'logo.png' AS Picture1,
'logo.png' AS Picture2
FROM cte2 C
LEFT JOIN PROFIL P ON C.NAME = P.NAME
WHERE TYPE = 101 AND P.BESTELLUNG <> ''