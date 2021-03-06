--! qt:dataset:src
--! qt:dataset:part
set hive.mapred.mode=nonstrict;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
set hive.merge.mapfiles=false;	
set hive.merge.mapredfiles=false; 
set mapred.input.dir.recursive=true;

-- Tests truncating a column from a list bucketing table


CREATE TABLE test_tab_n3 (key STRING, value STRING) PARTITIONED BY (part STRING) STORED AS RCFILE;

ALTER TABLE test_tab_n3
SKEWED BY (key) ON ("484")
STORED AS DIRECTORIES;

INSERT OVERWRITE TABLE test_tab_n3 PARTITION (part = '1') SELECT * FROM src;

set hive.optimize.listbucketing=true;
SELECT * FROM test_tab_n3 WHERE part = '1' AND key = '0';

TRUNCATE TABLE test_tab_n3 PARTITION (part ='1') COLUMNS (value);

-- In the following select statements the list bucketing optimization should still be used
-- In both cases value should be null

EXPLAIN EXTENDED SELECT * FROM test_tab_n3 WHERE part = '1' AND key = '484';

SELECT * FROM test_tab_n3 WHERE part = '1' AND key = '484';

EXPLAIN EXTENDED SELECT * FROM test_tab_n3 WHERE part = '1' AND key = '0';

SELECT * FROM test_tab_n3 WHERE part = '1' AND key = '0';
