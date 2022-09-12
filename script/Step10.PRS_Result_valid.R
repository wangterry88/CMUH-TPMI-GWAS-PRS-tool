setwd("./")
#############

cat(prompt="Input PRS result data (Ex: ./valid/result/test.all_score)(Full directory): ")
VALID_RESULT_PATH<-readLines(con="stdin",1)

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
library(ggplot2)
##############

# After PRS validation

# TPMI Info

TPMI.list.after<-fread("./TPMI-list/TPMI-29W-PTID-Name.txt",sep="\t")
TPMI.list.after<-TPMI.list.after[,c("GenotypeName","PatientID","PatientName","IdNo","Sex","Age")]

# PRS result

PRS.valid<-fread(VALID_RESULT_PATH,sep=" ")
PRS.valid<-PRS.valid[,c(1,2,3)]
colnames(PRS.valid)<-c("FID","IID","PRS")

# Make Quantiles Ranks

PRS.valid$Risk_Rank<-ntile(PRS.valid$PRS,100)
PRS.valid<-PRS.valid[,c("IID","PRS","Risk_Rank")]

PRS.valid.print<-left_join(PRS.valid,TPMI.list.after,by=c("IID"="GenotypeName"))
PRS.valid.print$Sex<-recode_factor(PRS.valid.print$Sex,"1"="Male","2"="Female")

cat(prompt="Input the Patient name : ")
PAT_NAME<-readLines(con="stdin",1)
cat('\n')

query_PRS<-subset(PRS.valid.print,PRS.valid.print$PatientName==PAT_NAME)
query_PRS<-query_PRS[,c("PatientName","IdNo","PatientID","Sex","Age","PRS","Risk_Rank")]

cat('\n')
print(query_PRS)
cat('\n')
cat('\n')

# Plot the data

cat(prompt="PRS valid result Plot (Short Name): ")
PLOT_VALID_OUT<-readLines(con="stdin",1)

PRS.valid.plot<-PRS.valid.print[,c("PRS","Risk_Rank","PatientName")]
PRS.valid.plot$Selection=ifelse(PRS.valid.plot$PatientName==PAT_NAME,"Selected","CMUH")

tmp_PRS_valid_plot<-paste0('./valid/plot/',PLOT_VALID_OUT,'.result-Plot.png',collapse = '')
png(tmp_PRS_valid_plot,height = 500,width  = 500)

ggplot(PRS.valid.plot, aes(x = PRS, y =Risk_Rank , colour = Selection)) +
scale_color_manual(values = c("CMUH" = "lightgrey", "Selected" = "red"))+
geom_point(size = 3, alpha=0.4)

dev.off()

cat('The plot were output in:',tmp_PRS_valid_plot)
cat('\n')
cat('\n')