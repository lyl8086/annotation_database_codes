USE idmapping;
/*
zcat data.gz | mysql -u root idmapping -e "LOAD DATA LOCAL INFILE '/dev/fd/0' INTO TABLE gene2ensembl FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';"
1. tax_id
2. GeneID
3. Ensembl_gene_identifier
4. RNA_nucleotide_accession.version
5. Ensembl_rna_identifier
6. protein_accession.version
7. Ensembl_protein_identifier
*/

drop table if exists `gene2ensembl`;
CREATE TABLE `gene2ensembl` (
  `taxid` varchar(32) NOT NULL default '',
  `geneid` varchar(32) NOT NULL default '',
  `ensmb` varchar(32) NOT NULL default '',
  `ncbitrs` varchar(32) NOT NULL default '',
  `ensmbtrs` varchar(32) NOT NULL default '',
  `refseq` varchar(32) NOT NULL default '',
  `ensmbpro` varchar(32) NOT NULL default '',
  PRIMARY KEY (`ensmbtrs`),
  KEY (`taxid`),
  KEY (`geneid`),
  KEY (`ensmb`),
  KEY (`ncbitrs`),
  KEY (`refseq`),
  KEY (`ensmbpro`)
) ENGINE=InnoDB;
