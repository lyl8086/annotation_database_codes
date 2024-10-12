USE idmapping;
/*
LOAD DATA LOCAL INFILE '/dev/fd/0' INTO TABLE uniprot_select FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';
1. UniProtKB-AC
2. UniProtKB-ID
3. GeneID (EntrezGene)
4. RefSeq
5. GI
6. PDB
7. GO
8. UniRef100
9. UniRef90
10. UniRef50
11. UniParc
12. PIR
13. NCBI-taxon
14. MIM
15. UniGene
16. PubMed
17. EMBL
18. EMBL-CDS
19. Ensembl
20. Ensembl_TRS
21. Ensembl_PRO
22. Additional PubMed
*/

drop table if exists `uniprot_select`;
CREATE TABLE `uniprot_select` (
  `uniac` varchar(32) NOT NULL default '',
  `uniid` varchar(32) NOT NULL default '',
  `geneid` int(32) NOT NULL default '0',
  `refseq` varchar(32) NOT NULL default '',
  `gi` text NOT NULL,
  `pdb` varchar(32) NOT NULL default '',
  `go` text NOT NULL,
  `uni100` varchar(32) NOT NULL default '',
  `uni90` varchar(32) NOT NULL default '',
  `uni50` varchar(32) NOT NULL default '',
  `uniparc` varchar(32) NOT NULL default '',
  `pir` varchar(32) NOT NULL default '',
  `tax` int(32) NOT NULL default '0',
  `mim` varchar(32) NOT NULL default '',
  `unigene` varchar(32) NOT NULL default '',
  `pubmed` text NOT NULL,
  `embl` varchar(32) NOT NULL default '',
  `emblcds` varchar(32) NOT NULL default '',
  `ensmb` varchar(32) NOT NULL default '',
  `ensmbtrs` varchar(32) NOT NULL default '',
  `ensmbpro` varchar(32) NOT NULL default '',
  `pubmeda` varchar(32) NOT NULL default '',
  PRIMARY KEY (`uniac`),
  KEY (`uniid`),
  KEY (`geneid`),
  KEY (`refseq`),
  KEY (gi(32)),
  KEY (`pdb`),
  KEY (`uni100`),
  KEY (`uni90`),
  KEY (`uni50`),
  KEY (`uniparc`),
  KEY (`pir`),
  KEY (`tax`),
  KEY (`embl`),
  KEY (`emblcds`),
  KEY (`ensmb`),
  KEY (`ensmbtrs`),
  KEY (`ensmbpro`)
) ENGINE=MyISAM
PARTITION BY Key()
PARTITIONS 20;

