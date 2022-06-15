#!/usr/bin/env bash
# Step 1: generate the contact maps file
echo "Step 1: generate contact map"
bash $FITHICDIR/utils/validPairs2FitHiC-fixedSize.sh 40000 IMR90 \
$DATADIR/validPairs/IMR90_HindIII_r4.hg19.bwt2pairs.withSingles.mapq30.validPairs.gz \
$DATADIR/contactCounts
# Step 2: generate the fragment mappability file
echo "Step 2: generate fragment mappability file"
python3 $FITHICDIR/utils/createFitHiCFragments-fixedsize.py \
—chrLens $DATADIR/referenceGenomes/hg19wY-lengths \
—resolution 40000 \
—outFile $DATADIR/fragmentMappability/IMR90_fithic.fragmentsfile.gz
# Step 3: generate the fragment mappability file, for a non-fixed-size dataset
echo "Step 3: generate non-fixed size fragment mappability file"
bash $FITHICDIR/utils/createFitHiCFragments-nonfixedsize.sh $DATADIR/\
fragmentMappability/yeast_fithic.fragments HindIII \
$DATADIR/referenceGenomes/yeast_reference_sequence_R62-1-1_20090218.fsa
# Step 4: compute bias files for yeast, ...
echo "Step 4: generate yeast bias files"
python3 $FITHICDIR/utils/HiCKRy.py \
-i $DATADIR/contactCounts/Duan_yeast_EcoRI.gz \
-f $DATADIR/fragmentMappability/Duan_yeast_EcoRI.gz \
-o $DATADIR/biasValues/Duan_yeast_EcoRI.gz
# ... for the whole genome human ...
echo "Step 4: generate wholegen human bias files"
python3 $FITHICDIR/utils/HiCKRy.py \
-i $DATADIR/contactCounts/Dixon_IMR90-wholegen_40kb.gz \
-f $DATADIR/fragmentMappability/Dixon_IMR90-wholegen_40kb.gz \
-o $DATADIR/biasValues/Dixon_IMR90-wholegen_40kb.gz
# ... and for the human chromosome 5
echo "Step 4: generate chr5 human bias files"
python3 $FITHICDIR/utils/HiCKRy.py \
-i $DATADIR/contactCounts/Rao_GM12878-primary-chr5_5kb.gz \
-f $DATADIR/fragmentMappability/Rao_GM12878-primary-chr5_5kb.gz \
-o $DATADIR/biasValues/Rao_GM12878-primary-chr5_5kb.gz
