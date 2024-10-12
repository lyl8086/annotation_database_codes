#!/usr/bin/perl
die "$0 [gzipped_uniprot_fasta] [out_name]\n" unless @ARGV >= 1;

my $infile = $ARGV[0];
my $out    = $ARGV[1];
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

open(OUT, "| gzip -c >$out");
print OUT "accession	accession.version	taxid	gi", "\n";

while(<$in_fh>) {
    next if !/^>/;
    />([^\s]+).+OX=([^\s]+)/;
    ($id, $taxid) = ($1,$2);
    if ($id =~ /\|/) {my @p = split(/\|/, $id); $id = $p[1];}
    print OUT join("\t", $id,$id,$taxid,0), "\n";
}
close OUT
