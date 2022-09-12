#!/bin/bash

echo "Enter the GWAS phenotype file (Full directory): "
read PHENO_COV  

echo "Output name of the GWAS result (Short Name): "
read GWAS_OUTPUT

BFILE=/media/volume1/bioinfo/TPMI_Array/TPMI_29W_RAW/TPMI_29W_RAW

./tools/plink2 \
--bfile ${BFILE} \
--covar ${PHENO_COV} \
--covar-name Sex,Age \
--chr 1-22 \
--geno 0.05 \
--glm firth-fallback hide-covar \
--hwe 0.00001 \
--mind 0.1 \
--ci 0.95 \
--out ./GWAS/${GWAS_OUTPUT} \
--pheno ${PHENO_COV} \
--pheno-name Pheno \
--memory 256000 \
--threads 120
#--maf 0.01 \



