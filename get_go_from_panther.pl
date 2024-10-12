#!/usr/bin/perl
# extract go from uniprot accession
#
# tsv file generated using:
#
# 
#
# 1. mapping gene_id with uniprot ac from the blast tsv file
# 2. retrive go from mysql panther database using uniprot ac

use strict;
use warnings;
use DBI;
use List::MoreUtils qw{uniq};
use Storable;
die "$0 [blast tsv file]\n" unless @ARGV == 1;
my $blast     = $ARGV[0];
my (%acc_gene, $gene_go, $go_anno);
my %go_term = (
    'MF'=>'go_function',
    'CC'=>'go_component',
    'BP'=>'go_process',
    'molecular_function'=>'go_function',
    'cellular_component'=>'go_component',
    'biological_process'=>'go_process',
    'F'=>'go_function',
    'P'=>'go_process',
    'C'=>'go_component'
);
my $driver="DBI:mysql";
my $database="idmapping";
my $user="liyulong";
my $host="localhost";
my $passwd="XXX";
my $rules="go";
my $dbh = DBI->connect("$driver:database=$database;host=$host;user=$user;password=$passwd")
or die "Can't connect: " . DBI->errstr;

sub get_go {
    # get go from ac list.
    my $ac    = shift;
    my $cache = "$blast.cache";
    if ($use_cache) {
        if (-f "$cache") {
            my $t1    = (stat($cache))[9];
            my $t2    = (stat($blast))[9];
            if ( $t1 > $t2) {
                $gene_go = retrieve("$cache");
                return;
            }
        }
    }
    foreach my $acc (@$ac) {
        my $sql = "select $rules from uniprot_select where uniac='$acc'";
        #print STDERR $sql;
        my $sth=$dbh->prepare($sql);
        $sth->execute() or die "Can't prepare sql statement". $sth->errstr;
        my @recs   = $sth->fetchrow_array;
        #print STDERR "  $recs[0]\n";
        my $gos    = $recs[0];
        if ($gos && $gos =~ /GO:/) {
            my @p  = split(/;/, $gos);
            my @GO = ();
            map {$_=~s/^\s+|\s+$//g; push @GO, $_;} @p;
            push @{$gene_go->{$acc_gene{$acc}}}, @GO;
        } 
        #$sth->finish();
    }
    store $gene_go, "$cache" if $use_cache;
}

sub get_ac_from_tsv {
    #1       1       1       Hualu_000001-T1 Hualu_000001    0.0     1603.6  A0A385FP91      Sodium/hydrogen exchanger OS=Lateolabrax maculatus OX=315492 GN=NHE5 PE=2 SV=1
    #4       2       1       Hualu_000004-T1 Hualu_000004    1.3e-52 215.7   A0A3B4TVC7      Formin_GBD_N domain-containing protein OS=Seriola dumerili OX=41447 PE=4 SV=1
    #
    my $tsv = shift;
    open(my $in_fh, "$tsv") or die "$!";
    while(<$in_fh>) {
        next if /^$|^#/;
        my @p = split(/\t/);
        my $gene = (split(/\|/,$p[1]))[2];
        my $ac   = $p[6];
        $acc_gene{$ac} = $gene;
    }

}

sub get_anno_from_DB {
    my $db    = shift;
    my $cache = "$db.cache";
     if ($use_cache) {
        if (-f "$cache") {
            my $t1    = (stat($cache))[9];
            my $t2    = (stat($db))[9];
            if ( $t1 > $t2) {
                $go_anno = retrieve("$cache");
                return;
            }
        }
    }
    open(my $in_fh, "$db") or die "$!";
    my $header = <$in_fh>;
    while(<$in_fh>) {
        #
        # go_id   go_id   Term    Ontology        Definition      Synonym Secondary
        # go_process	axon guidance|0007411||IEA
        next if /^$|^#/;
        chomp;
        my @parts = split(/\t/);
        my $go   = $parts[0];
        my $id   = (split(/:/, $go))[1];
        my $term = $parts[2];
        my $onto = $parts[3];
        $go_anno->{$go} = $go_term{$onto}."\t".$term. '|' . $id. '||IEA';
    }
    close $in_fh;
    store $go_anno, "$cache" if $use_cache;
}
#
get_ac_from_tsv($blast);
my @ac = (keys %acc_gene);
get_go(\@ac);
get_anno_from_DB($go_db);

# output.
foreach my $gene (sort keys %$gene_go) {
    my @ui = uniq(@{$gene_go->{$gene}});
    map { if (not defined $go_anno->{$_}) 
    {warn "$_ is not in go db\n"; next}
    print $gene, "\t", $go_anno->{$_}, "\n";} @ui;
}
