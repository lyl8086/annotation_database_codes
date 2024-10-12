p="/opt/bio/Apollo/bin"
genome=$1
gff=$2
out=$3
if [ $# -ne 3 ]; then echo $0 [genome] [gff] [out]; exit 1;fi

# index fasta
samtools faidx $genome 
$p/prepare-refseqs.pl --indexed_fasta $genome --out $out
# index all gff
# $p/flatfile-to-json.pl --gff $gff --trackType CanvasFeatures --trackLabel All --out $out

# index gene
$p/flatfile-to-json.pl --gff $gff --trackType CanvasFeatures --type gene --trackLabel Gene --out $out
# index cds.
$p/flatfile-to-json.pl --gff $gff --trackType CanvasFeatures --type CDS --trackLabel CDS --out $out
# index mRNA
$p/flatfile-to-json.pl --gff $gff --trackType CanvasFeatures --type mRNA --trackLabel mRNA --out $out
# index repeats
$p/flatfile-to-json.pl --gff $out/repeats.gff --trackType CanvasFeatures --trackLabel repeats --out $out
# index intron
# $p/flatfile-to-json.pl --gff $gff --trackType CanvasFeatures --type intron --trackLabel Intron --out $out
# index names.
$p/generate-names.pl -v --mem 10000000000 --completionLimit 100 --out $out

# add features.
#/opt/bio/Apollo-2.5.0/tools/data/add_features_from_gff3_to_annotations.pl \
#-U localhost:8080/apollo -u XXX -p XXX \
#-i $gff -t mRNA -o $out

