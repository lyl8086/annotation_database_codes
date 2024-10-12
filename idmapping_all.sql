USE idmapping;
/*
LOAD DATA LOCAL INFILE '22' INTO TABLE uniprot_acc FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE '/dev/fd/0' INTO TABLE uniprot_acc FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';
1. UniProtKB-AC
2. ID_type
3. ID
*/

drop table if exists `uniprot_acc`;
CREATE TABLE `uniprot_acc` (
  `uniac`  varchar(32) NOT NULL default '',
  `idtype` varchar(32) NOT NULL default '',
  `id`     text NOT NULL,
  KEY `index_ac` (`uniac`),
  KEY `index_type` (`idtype`),
  KEY `index_id` (id(32))
) ENGINE=MyISAM
PARTITION BY Key(uniac)
PARTITIONS 40;

