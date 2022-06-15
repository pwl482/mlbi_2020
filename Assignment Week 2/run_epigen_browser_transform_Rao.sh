#!/usr/bin/env bash
# Step 14: format for the Epigenome Browser
echo "Step 14: format chr5 human data for Epigenome Browser"
zcat $DATADIR/fithicOutput/Rao_GM12878-primary-chr5_5kb/Rao_GM12878-\
primary-chr5_5kb.spline_pass1.res5000.significances.txt.gz | awk -v \
q=1e-10 '{if($7 < q) {print $0}}' | awk -F['\t'] '{if(NR>1) {if($NF>0) \
{print $1"\t"($2-1)"\t"($2+1)"\t"$3":"($4-1)"-"($4+1)","(-log($7)/\
log(10))"\t"(NR-1)"\t."} else { print $1"\t"($2-1)"\t"($2+1)"\t"$3":\
"($4-1)"-"($4+1)",500\t"(NR-1)"\t."}}}' | sort -k1,1 -k2,2n > $DATADIR/\
fithicOutput/Rao_GM12878-primary-chr5_5kb/washu_browser_format.bed
# Step 15: zip and index the bed file
echo "Step 15: zip and index the bed file for Epigenome Browser"
bgzip $DATADIR/fithicOutput/Rao_GM12878-primary-chr5_5kb/washu_browser_\
format.bed
tabix $DATADIR/fithicOutput/Rao_GM12878-primary-chr5_5kb/\
washu_browser_format.bed.gz -f -p bed
