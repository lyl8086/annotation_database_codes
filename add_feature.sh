p="/opt/bio/Apollo-2.5.0/bin"
gff=$1
out=$2

if [ $# -ne 2 ]; then echo $0 [gff] [out]; exit 1;fi

# add features.
/opt/bio/Apollo-2.5.0/tools/data/add_features_from_gff3_to_annotations.pl \
-U localhost:8080/apollo -u XXX -p XXX \
-i $gff -t mRNA -o $out