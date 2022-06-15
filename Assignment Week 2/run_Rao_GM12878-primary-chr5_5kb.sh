#!/usr/bin/env bash
# Step 6: run FitHiC with Rao_GM12878-primary-chr5_5kb
echo "Step 6: run FitHiC with chr5 human data"
python3 $FITHICDIR/fithic.py \
-i $DATADIR/contactCounts/Rao_GM12878-primary-chr5_5kb.gz \
-f $DATADIR/fragmentMappability/Rao_GM12878-primary-chr5_5kb.gz \
-t $DATADIR/biasValues/Rao_GM12878-primary-chr5_5kb.gz \
-r 5000 \
-o $DATADIR/fithicOutput/Rao_GM12878-primary-chr5_5kb \
-l Rao_GM12878-primary-chr5_5kb \
-U 1000000 \
-L 15000 \
-v
# Step 7: create an HTML summary page
echo "Step 7: create a HTML summary page"
bash $FITHICDIR/utils/createFitHiCHTMLout.sh Rao_GM12878-primary-\
chr5_5kb 1 $DATADIR/fithicOutput/Rao_GM12878-primary-chr5_5kb
# Step 13: merge significant interactions
echo "Step 13: merge significant interactions"
cd $FITHICDIR
cd utils
bash merge-filter.sh $DATADIR/fithicOutput/Rao_GM12878-primary-chr5_\
5kb/Rao_GM12878-primary-chr5_5kb.spline_pass1.res5000.significances.\
txt.gz 5000 $DATADIR/fithicOutput/Rao_GM12878-primary-chr5_5kb/Rao_\
GM12878-primary-chr5_5kb-merged.gz 0.01
