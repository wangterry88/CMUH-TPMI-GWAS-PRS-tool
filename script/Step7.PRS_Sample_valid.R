setwd("./")
#############

cat(prompt="Input Fam file of PRS data (Ex: ./PRS/data/test.fam)(Full directory): ")
FAM_PATH<-readLines(con="stdin",1)

cat(prompt="Output Query list (Short Name): ")
FINAL_LIST<-readLines(con="stdin",1)



######### Install packages ###########


##### ggplot2 ######
if("ggplot2" %in% rownames(installed.packages()) == FALSE) {
	install.packages("ggplot2",repos = "http://cran.us.r-project.org")
}


##### data.table ######
if("data.table" %in% rownames(installed.packages()) == FALSE) {
        install.packages("data.table",repos = "http://cran.us.r-project.org")
}

##### dplyr ######
if("dplyr" %in% rownames(installed.packages()) == FALSE) {
        install.packages("dplyr",repos = "http://cran.us.r-project.org")
}

##### pROC ######
if("pROC" %in% rownames(installed.packages()) == FALSE) {
        install.packages("pROC",repos = "http://cran.us.r-project.org")
}


#############

library(data.table)
library(dplyr)

##############

# Fam

Valid.list<-fread(FAM_PATH,header = F)
Valid.list<-Valid.list[,c(1,2)]
colnames(Valid.list)<-c("FID","IID")

# TPMI list

TPMI.list<-fread("./TPMI-list/TPMI-29W-PTID-Name.txt")
TPMI.list.info<-TPMI.list[,c("PatientID","PatientName","IdNo","Sex","Age")]
TPMI.list.info$Sex<-recode_factor(TPMI.list.info$Sex,"1"="Male","2"="Female")

# Sample selection:

cat(prompt="Input Query Patient Name: ")
PAT_NAME<-readLines(con="stdin",1)
cat('\n')

select<-subset(TPMI.list.info,TPMI.list.info$PatientName==PAT_NAME)
print(select)
cat('\n')

cat(prompt="Input Query Patient ID: ")
PAT_ID<-readLines(con="stdin",1)

select.keeplist<-subset(TPMI.list,TPMI.list$PatientID==PAT_ID)
select.keeplist<-select.keeplist[,c("GenotypeName","GenotypeName")]
colnames(select.keeplist)<-c("FID","IID")

final.valid.list<-rbind(select.keeplist,Valid.list)

# Output Keep list:
tmp.final.list<-paste0('./valid/list/',FINAL_LIST,'.txt',collapse = '')
fwrite(final.valid.list,tmp.final.list,sep="\t",col.names = F)
cat('\n')
cat('New Keep list have already write into:',tmp.final.list)
cat('\n')