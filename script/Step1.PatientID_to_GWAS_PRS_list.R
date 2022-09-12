setwd("./")

#args = commandArgs(trailingOnly=TRUE)

cat(prompt="Input your patient list (Full directory): ")
Input_list<-readLines(con="stdin",1)

cat(prompt="Output file name (Short Name): ")
Output_name<-readLines(con="stdin",1)

library(data.table)
library(dplyr)

# read file

Input<-fread(Input_list,sep="\t",header=T)
TPMI_list<-fread("./TPMI-list/TPMI-29W-PTID-Name.txt",sep="\t",header=T)

# Check duplicate
colnames(Input)[1]<-"PatientID"
colnames(Input)[2]<-"Pheno"
Input_unique<-distinct(Input,PatientID,.keep_all = T)

# Count number of duplicate
num_dup=nrow(Input)-nrow(Input_unique)
cat('\n')
cat('##### Input Sample Information #####')
cat('\n')
cat('\nInput Sample Num. is:', nrow(Input))
cat('\nInput Sample Num. duplicated is:', num_dup)
cat('\nInput Sample Num. unique is:', nrow(Input_unique))
cat('\n')

# Get Patients with (without) TPMI

Patient_List_TPMI<-left_join(Input,TPMI_list,,by=c("PatientID"="PatientID"))

# Check duplicate

Patient_List_TPMI_unique=distinct(Patient_List_TPMI,PatientID,.keep_all = T)

# Get the list of TPMI with PatientID

no_chip=subset(Patient_List_TPMI_unique,is.na(Patient_List_TPMI_unique$GenotypeName))
have_chip=subset(Patient_List_TPMI_unique,!is.na(Patient_List_TPMI_unique$GenotypeName))

cat('\n')
cat('##### TPMI Chip Information #####')
cat('\n')
cat('\nSample Num. with TPMI chip is:', nrow(have_chip))
cat('\nSample Num. without TPMI chip is:', nrow(no_chip))
cat('\n')
cat('\n')

# Output the data

tmp_no_chip=paste0('./output/',Output_name,'-no-chip-list.txt',collapse = '')
tmp_have_chip=paste0('./output/',Output_name,'-have-chip-list.txt',collapse = '')

fwrite(no_chip,tmp_no_chip,sep="\t",col.names = T)
fwrite(have_chip,tmp_have_chip, sep="\t",col.names = T)

# Make the GWAS-ready Pheno table

have_chip_GWAS=have_chip[,c("GenotypeName","GenotypeName","Sex","Age","Pheno")]
colnames(have_chip_GWAS)<-c("FID","IID","Sex","Age","Pheno")

case=subset(have_chip_GWAS,have_chip_GWAS$Pheno=="1")    
control=subset(have_chip_GWAS,have_chip_GWAS$Pheno=="2")

cat('\n')
cat('##### TPMI Chip for GWAS + PRS Information #####')
cat('\n')
cat('\nNum. of GWAS + PRS in case is:', nrow(control))
cat('\nNum. of GWAS + PRS in control is:', nrow(case))
cat('\n')
cat('\n')

cat('######### GWAS PRS data Sepration #####')
cat('\n')
cat('\n')
cat(prompt="Please specify GWAS rate(ex: 0.8): ")
training_rate<-as.numeric(readLines(con="stdin",1))

# Sample collection 8:2

### Control ####

smp_size_control <- floor(training_rate * nrow(control))
train_ind_control <- sample(seq_len(nrow(control)), size = smp_size_control)

train_control <- control[train_ind_control, ]
test_control <-  control[-train_ind_control, ]

### Case ####

smp_size_case <- floor(training_rate * nrow(case))
train_ind_case <- sample(seq_len(nrow(case)), size = smp_size_case)

train_case <- case[train_ind_case, ]
test_case <-  case[-train_ind_case, ]

# Combine the randomm seleted case control data

train.data<-rbind(train_control,train_case)
test.data<-rbind(test_control,test_case)
cat('\n')
cat('\n')
cat('##### Information of GWAS data  #####')
cat('\n')
cat('\n')
train.data$Pheno<-as.factor(train.data$Pheno)
summary(train.data)
cat('\n')
cat('##### Information of PRS data  #####')
cat('\n')
cat('\n')
test.data$Pheno<-as.factor(test.data$Pheno)
summary(test.data)
cat('\n')
cat('##### Output of GWAS PRS Pheno table  #####')
cat('\n')

# Output the data

tmp_gwas=paste0('./pheno/',Output_name,'.GWAS.pheno.txt',collapse = '')
tmp_prs=paste0('./pheno/',Output_name,'.PRS.pheno.txt',collapse = '')
fwrite(train.data,tmp_gwas,sep="\t",col.names = T)
fwrite(test.data,tmp_prs, sep="\t",col.names = T)

cat('\n')
cat('##### GWAS PRS Sepration successfully #####\n')
cat('\n')
cat('\n')
cat('##### GWAS-ready Information #####')
cat('\n')
cat('\n The GWAS-ready Phenotype table was output in:',tmp_gwas)
cat('\n')
cat('\n')
cat('##### PRS-ready Information #####')
cat('\n')
cat('\n The PRS-ready Phenotype table was output in:',tmp_prs)
cat('\n')
cat('\n Ready for Next step: GWAS Analysis......')
cat('\n')
cat('\n')