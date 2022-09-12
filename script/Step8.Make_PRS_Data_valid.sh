#!/bin/bash

echo "Enter the Keep list file (Full directory): "
read KEEP_LIST 

echo "Output name of the PRS valid bfile data (Short Name): "
read PRS_DATA_VALID

BFILE=/media/volume1/bioinfo/TPMI_Array/TPMI_29W_RAW/TPMI_29W_RAW

./tools/plink2 \
--bfile ${BFILE} \
--keep ${KEEP_LIST} \
--make-bed \
--memory 500000 \
--no-pheno \
--out ./valid/data/${PRS_DATA_VALID} \
--threads 120