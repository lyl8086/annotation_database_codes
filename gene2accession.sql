USE idmapping;
/*
zcat data.gz | mysql -u root idmapping -e "LOAD DATA LOCAL INFILE '/dev/fd/0' INTO TABLE gene2accession FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';"
1. tax_id
2. GeneID
3. status
4. RNA_nucleotide_accession.version
5. RNA_nucleotide_gi
6. protein_accession.version
7. protein_gi
8. genomic_nucleotide_accession.version
9. genomic_nucleotide_gi
10. start_position_on_the_genomic_accession
11. end_position_on_the_genomic_accession
12. orientation
13. assembly
14. mature_peptide_accession.version
15. mature_peptide_gi
16. Symbol
*/

drop table if exists `gene2accession`;
CREATE TABLE `gene2accession` (
  `taxid` varchar(32) NOT NULL default '',
  `geneid` varchar(32) NOT NULL default '',
  `status` varchar(32) NOT NULL default '',
  `rna` varchar(32) NOT NULL default '',
  `rnagi` varchar(32) NOT NULL default '',
  `refseq` varchar(32) NOT NULL default '',
  `protgi` varchar(32) NOT NULL default '',
  `nuc` varchar(32) NOT NULL default '',
  `nucgi` varchar(32) NOT NULL default '',
  `start` varchar(32) NOT NULL default '',
  `end` varchar(32) NOT NULL default '',
  `strand` varchar(32) NOT NULL default '',
  `assembly` varchar(32) NOT NULL default '',
  `mature` varchar(32) NOT NULL default '',
  `maturegi` varchar(32) NOT NULL default '',
  `symbol` varchar(32) NOT NULL default '',
  PRIMARY KEY (`refseq`),
  KEY (`geneid`),
  KEY (`rna`),
  KEY (`rnagi`),
  KEY (`protgi`),
  KEY (`nuc`),
  KEY (`nucgi`),
  KEY (`mature`),
  KEY (`maturegi`),
  KEY (`symbol`)
) ENGINE=MyISAM;
