#!/usr/bin/perl

use strict;
use warnings;

my $in  = $ARGV[0];
my $out = $ARGV[1];
die "$0 [in] [out_prefix]\n" unless @ARGV == 2;

open(IN, "$in") or die "$!";
open(GO,">$out.go") or die "$!";
open(KEGG,">$out.kegg") or die "$!";
open(ANN,">$out.annot.xls") or die "$!";

while(<IN>) {
    chomp;
    #id uniprot genename genefamily proteinclass species pathway MF BP CC
    next if /^$|^#/;
    my @p = split(/\t/);
    my @go = ();
    my ($acc,  $genefam, $protclass, $path,) = ($p[1],$p[3], $p[4], $p[6]);
    my @genenames =  split(';',$p[2]);
    my @mf = split(';',$p[7]);
    my @bp = split(';',$p[8]);
    my @cc = split(';',$p[9]);
    print ANN join("\t", $acc, $genenames[0], $genefam, $protclass),"\n";
    map{/\((GO:\d+)\)/;push @go, $1;}(@mf,@bp,@cc);
    print GO join("\t", $acc, join(",",@go)),"\n";
    print KEGG join("\t", $acc,$path),"\n";
}
