USE idmapping;
/*
LOAD DATA LOCAL INFILE '/dev/fd/0' INTO TABLE panther FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';
1. Gene Identifier
2. Protein ID
3. EnsemblGenome ID
4. PANTHER SF ID
5. PANTHER Family Name
6. PANTHER Subfamily Name
7. PANTHER Molecular function
8. PANTHER Biological process
9. Cellular components
10. Protein class
11. Pathway
*/

drop table if exists `panther`;
CREATE TABLE `panther` (
  `id` varchar(80) NOT NULL default '',
  `uniprot` varchar(32) NOT NULL default '',
  `EnsemblGenome` varchar(32) NOT NULL default '',
  `panther` varchar(32) NOT NULL default '',
  `fam` text NOT NULL,
  `subfam` text NOT NULL,
  `mf` text NOT NULL,
  `bp` text NOT NULL,
  `cc` text NOT NULL,
  `pro_class` text NOT NULL,
  `pathway` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY (`uniprot`),
  KEY (`panther`)
) ENGINE=MyISAM;


