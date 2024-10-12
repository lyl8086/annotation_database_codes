#!/usr/bin/perl
# convert bio accesions based on Uniprot idmapping.
use strict;
use warnings;
use DBI;
my $ac_file = $ARGV[0];
my $from    = $ARGV[1];
my $to      = $ARGV[2];
my %FMT = (
    "ENSEMBL" => 'ensmb',
    "ENSEMBLPROT" => 'ensmbpro',
    "ENSEMBLTRANS" => 'ensmbtrs',
    "ENTREZID" => 'geneid',
    "UNIPROT" => 'uniac',
    "REFSEQ" => 'refseq',
);

die "$0 [ac_file] [from] [to]\n" unless @ARGV == 3;
foreach (($from, $to)) {
    die "  Unknown format '$_', accept ".join(",",keys %FMT).".\n" unless defined $FMT{$_};
}
my $has = 0;
my $tot = 0;
my $driver="DBI:mysql";
my $database="idmapping";
my $user="liyulong";
my $host="localhost";
my $passwd="XXX";
my $rules="go";
my $dbh = DBI->connect("$driver:database=$database;host=$host;user=$user;password=$passwd")
or die "Can't connect: " . DBI->errstr;

open(IN, "$ac_file") or die "$!";
open(OUT, ">unmapped.id") or die "$!";
while(<IN>) {
    chomp;
    next if /^#|^$/;
    $tot++;
    my $id  = (split(/\./, $_))[0];
    my $sql = "select $FMT{$to} from uniprot_select where $FMT{$from} = '$_'";
    my $sth=$dbh->prepare($sql);
    $sth->execute() or die "Can't prepare sql statement". $sth->errstr;
    my @recs   = $sth->fetchrow_array;
    if (not $recs[0]) {print OUT $_, "\n"; next;}
    print join("\t", $_, $recs[0]), "\n";
    $has++;
}
close IN;
close OUT;
print STDERR "Total $has/$tot mapped", "\n";


