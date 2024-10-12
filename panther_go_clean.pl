#!/usr/bin/perl
# clean the desc. of GO in PANTHER.
use strict;
use warnings;

my $in = shift;

open(IN, "$in") or die "$!";
while(<IN>) {
	#membrane-bounded organelle#GO:0043227;cellular anatomical entity#GO:0110165;organelle#GO:0043226;nucleus#GO:0005634;intracellular membrane-bounded organelle#GO:0043231;intracellular organelle#GO:0043229;intracellular#GO:0005622
	chomp;
	my @p = split(/\t/);
	#print scalar(@p), "\n";
	for (my $i=6; $i<9; $i++) {
		if($p[$i]) {
			my @go = $p[$i] =~ /#GO:(\d+)/g;
			if (scalar(@go) > 1) {
				$p[$i] = join(";", @go);
			} else {
				$p[$i] = $go[0];
			}
		}
	}
	print join("\t", @p), "\n";
}


	
	