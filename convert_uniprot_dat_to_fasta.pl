#!/usr/bin/perl
# covert uniprot dat file to fasta.
use strict;
use warnings;
# taxid mapping file:
# accession       accession.version       taxid   gi

# uniprot dat file:
# ID   13KDA_SCYCA             Reviewed;          14 AA.
# AC   P83011;
# DT   29-MAR-2005, integrated into UniProtKB/Swiss-Prot.
# DT   01-OCT-2001, sequence version 1.
# DT   11-DEC-2019, entry version 27.
# DE   RecName: Full=13.2 kDa protein;
# DE   Flags: Fragment;
# OS   Scyliorhinus canicula (Small-spotted catshark) (Squalus canicula).
# OC   Eukaryota; Metazoa; Chordata; Craniata; Vertebrata; Chondrichthyes;
# OC   Elasmobranchii; Galeomorphii; Galeoidea; Carcharhiniformes; Scyliorhinidae;
# OC   Scyliorhinus.
# OX   NCBI_TaxID=7830;
# RN   [1] {ECO:0000305}
# RP   PROTEIN SEQUENCE.
# RC   TISSUE=Rectal gland {ECO:0000269|PubMed:11676495};
# RX   PubMed=11676495; DOI=10.1006/bbrc.2001.5826;
# RA   Schuurmans Stekhoven F.M.A.H., Flik G., Wendelaar Bonga S.E.;
# RT   "N-terminal sequences of small ion channels in rectal glands of sharks: a
# RT   biochemical hallmark for classification and phylogeny?";
# RL   Biochem. Biophys. Res. Commun. 288:670-675(2001).
# CC   -!- SUBCELLULAR LOCATION: Microsome. Endoplasmic reticulum.
# CC   ---------------------------------------------------------------------------
# CC   Copyrighted by the UniProt Consortium, see https://www.uniprot.org/terms
# CC   Distributed under the Creative Commons Attribution (CC BY 4.0) License
# CC   ---------------------------------------------------------------------------
# DR   GO; GO:0005783; C:endoplasmic reticulum; IEA:UniProtKB-SubCell.
# DR   GO; GO:0043231; C:intracellular membrane-bounded organelle; IDA:UniProtKB.
# PE   1: Evidence at protein level;
# KW   Direct protein sequencing; Endoplasmic reticulum; Microsome.
# FT   CHAIN           1..>14
# FT                   /note="13.2 kDa protein"
# FT                   /id="PRO_0000064350"
# FT   NON_TER         14
# FT                   /evidence="ECO:0000303|PubMed:11676495"
# SQ   SEQUENCE   14 AA;  1575 MW;  89B2AE42D9B79D0A CRC64;
     # MIFTAXDRSA IEXV
# //
my $infile = $ARGV[0];
my ($in_fh, $id, $ac, $gn, $taxid, $tax, $full_name, $seq);
if (substr($infile, -2) eq 'gz') {
    open($in_fh, "gunzip -c $infile|") or die "$!";
    } 
elsif (substr($infile, -2) eq '7z') {
    open($in_fh, "7zcat.sh $infile|") or die "$!";
    }
else {
    open($in_fh, "$infile") or die "$!";
}

open(OUT, "| gzip -c >uniprot.idmapping.gz");
# new
# accession	accession.version	taxid	gi
print OUT join("\t",'accession','accession.version','taxid','gi'), "\n";

while(<$in_fh>) {

    if (/^ID\s+([^\s;\{]+)/) {
        $id = $1;
        next;
    }
    if (/^AC\s+([^\s;\{]+)/) {
        $ac = $1;
        next;
    }
    
    if (/^GN\s+Name=([^\s;\{]+)/) {
        $gn = $1;
        next;
    }
    
    if (/^OX\s+NCBI_TaxID=(\d+)/) {
        $taxid = $1;
        next;
    }
    
    if (/^OS\s+(.+)\.$/) {
        $tax = $1;
        next;
    }
    
    if (/^DE.+Full=([^\{;]+)/) {
        $full_name = $1;
        $full_name =~ s/^\s+|\s+$//g;
        next;
    }
    
    if (/^\s+/) {
        $_ =~ s/\s//g;
        $_ .= "\n";
        $seq .= $_;
        next;
    }
    if (/^\/\//) {
        # one record.
        $gn = $id if !$gn;
        print ">$ac  ", join("  ",$full_name,"GN=$gn","OX=$taxid","OS=$tax"), "\n";
        print $seq;
        print OUT join("\t",$ac,$ac,$taxid,0), "\n";
        $seq=$ac=$full_name=$gn=$taxid='';
        next;
    }
    
}
