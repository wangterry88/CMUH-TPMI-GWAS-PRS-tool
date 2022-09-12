#!/bin/bash

echo "Enter the Base file (GWAS summary stat.) (Full directory): "
read BASE  

echo "Enter the Target file (Valid) (Full directory): "
read TARGET 

echo "Output name of the PRS result (Valid) (Short name): "
read PRS_OUTPUT_VALID

echo "Enter the PRS model selected SNP (Ex: ./PRS/result/test.snp)(Full directory): "
read SELECTED_SNP

echo "Enter the PRS model summary (Ex: ./PRS/result/test.summary)(Full directory): "
read MODEL

awk '{print $3}' ${MODEL}

echo "Please input the bset P-threshold of PRS model: "
read MODEL_P

Rscript ./tools/PRSice2/PRSice.R \
--prsice ./tools/PRSice2/PRSice_linux \
--base ${BASE} \
--target ${TARGET} \
--bar-levels ${MODEL_P} \
--extract ${SELECTED_SNP} \
--stat OR \
--or \
--A1 A1 \
--pvalue P \
--score std \
--thread 64 \
--print-snp \
--seed 123456789 \
--quantile 10 \
--no-default \
--snp SNP \
--no-regress \
--no-clump \
--fastscore \
--out ./valid/result/${PRS_OUTPUT_VALID}