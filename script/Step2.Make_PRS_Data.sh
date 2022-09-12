#!/bin/bash

echo "Enter the PRS phenotype file (Full directory): "
read PHENO_COV  

echo "Output name of the PRS bfile data (Short Name): "
read PRS_DATA_OUTPUT

BFILE=/media/volume1/bioinfo/TPMI_Array/TPMI_29W_RAW/TPMI_29W_RAW

./tools/plink2 \
--bfile ${BFILE} \
--keep ${PHENO_COV} \
--make-bed \
--memory 500000 \
--no-pheno \
--out ./PRS/data/${PRS_DATA_OUTPUT} \
--threads 120