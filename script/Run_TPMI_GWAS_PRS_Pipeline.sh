#!/bin/bash
echo ""
echo ""
echo "This script is to run TPMI GWAS and PRS analysis."
echo ""
echo ""
echo "Please specify the new Project name:"
read PROJECT
echo ""
echo ""
cd .
mkdir ./${PROJECT}
mkdir ./GWAS
mkdir ./GWAS/plot
mkdir ./output
mkdir ./pheno
mkdir ./PRS
mkdir ./PRS/data
mkdir ./PRS/plot
mkdir ./PRS/result
mkdir ./valid
mkdir ./valid/data
mkdir ./valid/list
mkdir ./valid/result
mkdir ./valid/plot

echo ""
echo "This script is to run TPMI GWAS and PRS analysis."
echo ""
echo "############# Step1: Perform TPMI Chip Mapping.... ###########"
echo ""
Rscript ./script/Step1.PatientID_to_GWAS_PRS_list.R
echo ""
echo "############# Step2: Make PRS Data.... ###########"
echo ""
sh ./script/Step2.Make_PRS_Data.sh
echo ""
echo "############# Step3: Perform GWAS Anaysis.... ###########"
echo ""
sh ./script/Step3.GWAS.sh
echo "When example mode, GWAS step will be skipped"
echo ""
echo "Example output will be in the following folder:"
echo ""
echo "./GWAS/Example.GWASresult.txt"
echo ""
echo "############# Step4: Plot the GWAS Manhattan QQ Plot + PRS Base data.... ###########"
echo ""
Rscript ./script/Step4.Manhattan_QQ_Plot_PRSsumstat.R
echo ""
echo "############# Step5: Perform PRS Anaysis.... ###########"
echo ""
sh ./script/Step5.PRS.sh
echo ""
echo "############# Step6: Plot the PRS results.... ###########"
echo ""
Rscript ./script/Step6.PRS_plot.R
echo ""
echo "######### Step7: New Sample PRS calculation.... #########"
echo ""
Rscript ./script/Step7.PRS_Sample_valid.R
echo ""
echo "######### Step8: Make Raw data of New Sample.... #########"
echo ""
sh ./script/Step8.Make_PRS_Data_valid.sh
echo ""
echo "######### Step9: New Sample validation.... #########"
echo ""
sh ./script/Step9.PRS-valid.sh
echo ""
echo "######### Step10: Final New Sample validation.... #########"
echo ""
Rscript ./script/Step10.PRS_Result_valid.R
echo ""
echo "######### Final: Packaging ALL the results to your Project Folder.... #########"
echo ""
echo ""
mv ./GWAS ./${PROJECT}
mv ./output ./${PROJECT}
mv ./pheno ./${PROJECT}
mv ./PRS ./${PROJECT}
mv ./valid ./${PROJECT}
echo ""
echo ""
echo "#################################### Done #####################################"