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
my ($gene_to_ac, $ac_to_gene, $gene_go, $go_anno, @genes);
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

sub get_ac_from_tsv {
    #OG0000302	MARPO|EnsemblGenome=MARPO_0043s0081|UniProtKB=A0A2R6X164	52.8	1088	487	12	1	1080	1010	2079	0.0	1137
    #OG0000303	PHYRM|Gene=H3G926_PHYRM|UniProtKB=H3G926	71.7	378	107	0	13	390	17	394	2.33e-203	569

    my $tsv = shift;
    open(my $in_fh, "$tsv") or die "$!";
    while(<$in_fh>) {
        next if /^$|^#/;
        my @p = split(/\t/);
        my $gene = $p[0];
        my $ac   = (split(/\|/,$p[1]))[2];
        $ac =~ s/UniProtKB=//g;
        #print $ac,$p[1],"\n";
        push @genes, $gene;
        $gene_to_ac->{$gene} = $ac;
        push @{$ac_to_gene->{$ac}}, $gene;
    }

}

sub get_anno_from_DB {
    my $ac = shift;
    my @allgo;
    my $sql = "select * from panther_full where uniprot='$ac'";
    #print STDERR $sql;
    my $sth = $dbh->prepare($sql);
    $sth->execute() or die "Can't prepare sql statement". $sth->errstr;
    # | id | uniprot | EnsemblGenome | panther | fam | subfam | mf | bp | cc | pro_class | pathway |
    my @row = $sth->fetchrow_array();
    return unless @row;
    return(\@row);
}
#

get_ac_from_tsv($blast);

# output.

print join("\t", 'OG','id','uniprot','EnsemblGenome','panther','fam','subfam','mf','bp','cc','pro_class','pathway'),"\n";
foreach my $gene (@genes) {
    my $ac = $gene_to_ac->{$gene};
    my $b = get_anno_from_DB($ac);
    next unless $b;
    print join("\t",$gene, @$b),"\n";
}

