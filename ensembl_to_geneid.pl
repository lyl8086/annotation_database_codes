#!/usr/bin/perl
# convert bio accesions based on gene2ensembl idmapping.
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
    my @recs   = @{do_query($_)};
    @recs = @{do_query($id)} if !$recs[0];
    my $i = 0;
    while(!$recs[0]) {
        # try get gene id without version.
        # will try max iter = 10.
        ++$i;
        last if $i == 10;
        my $q  = $id . ".$i";
        next if $q eq $_;
        @recs   = @{do_query($q)};
    }
    
    if (not $recs[0]) {print OUT $_, "\n"; print join("\t", $_, "NA"), "\n"; next;}
    print join("\t", $_, $recs[0]), "\n";
    $has++;
}
close IN;
close OUT;
print STDERR "Total $has/$tot mapped", "\n";

sub do_query {
    my $id = shift;
    my $sql = "select $FMT{$to} from gene2ensembl where $FMT{$from} = '$id'";
    my $sth = $dbh->prepare($sql);
    $sth->execute() or die "Can't prepare sql statement". $sth->errstr;
    my @recs   = $sth->fetchrow_array;
    return(\@recs);
}
