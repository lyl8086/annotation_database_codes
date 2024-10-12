#!/usr/bin/perl
# get fasta name for uniref90 from target taxonomy id.

my $fa  = $ARGV[0];
my $tax = $ARGV[1];
my %taxonomy;
open(IN, $tax) or die "$!";
while(<IN>) {
    my @p = split;
    $taxonomy{$p[0]}++;
}
close IN;

open(IN, $fa) or die "$!";
while(<IN>) {
    #>UniRef90_A0A5A9P0L4 Peptidylprolyl isomerase n=1 Tax=Triplophysa tibetana TaxID=1572043 RepID=A0A5A9P0L4_9TELE
    /TaxID=(\d+)/i;
    next if not defined $taxonomy{$1};
    print;
}
close IN;

