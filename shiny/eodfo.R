eod_fo<-function(tar_date){
library(tibble)
library(sys)
library(curl)
library(tidyverse)

#Preparing URL string for download
#today<-toupper(format(Sys.Date()-3,"%d%b%Y"))
today<-toupper(format(tar_date,"%d%b%Y"))
downloadstr<-"https://www1.nseindia.com/content/historical/DERIVATIVES/2020/JAN/fo08JAN2020bhav.csv.zip"
substr(downloadstr,nchar(downloadstr)-20,nchar(downloadstr)-12)<-today
substr(downloadstr,nchar(downloadstr)-26,nchar(downloadstr)-24)<-substr(today,3,5)
substr(downloadstr,nchar(downloadstr)-31,nchar(downloadstr)-28)<-substr(today,6,9)

#Comment this line when files for latest date available
#downloadstr<-"https://www1.nseindia.com/content/historical/DERIVATIVES/2020/JAN/fo08JAN2020bhav.csv.zip"
req<-curl_fetch_memory(downloadstr)
s<-as.character(req$status_code)
if(!identical(s,"200")){
	return(s)
}

#Downloading File
tmp<-tempfile()
curl_download(downloadstr,tmp)
stat<-tryCatch(wb<-read.csv(unzip(tmp,exdir="../Others")),error=function(cond) {
            message(paste("File does not seem to exist: ", downloadstr))
            message("Here's the original error message:")
            message(cond)
            # Choose a return value in case of error
            return("404")
        },
        warning=function(cond) {
            message(paste("URL caused a warning:", downloadstr))
            message("Here's the original warning message:")
            message(cond)
            # Choose a return value in case of warning
            return("404")
        })
if(identical(stat,"404"))
{return("404")}
#curl_download(downloadstr,"indices.csv")
#wb <- read.csv("indices.csv")
wb1<-as_tibble(wb)
if(ncol(wb1)<=1)
{	return("404")}

#Removing CE and PE entries
wb1<-wb1[wb1$OPTION_TYP!="CE"&wb1$OPTION_TYP!="PE",]

#Reordering Columns
wb1<-wb1[,c(2,15,6,7,8,9,11,13)]

#Adding Open Interest Column
#wb1["Open.Interest"]<-0

#Replacing empty cells with 0
wb1<-sapply(wb1,as.character)
wb1[wb1=="-"]<-"0"

#Formatting Index name
wb1[,1]<-toupper(wb1[,1])
wb1[,1]<-gsub(' ','',wb1[,1])
wb1[,1]<-paste(wb1[,1],"-I",sep="")
ind<-which(duplicated(wb1[,1]))
while(length(ind)!=0)
{
	ind<-which(duplicated(wb1[,1]))
	wb1[ind,1]<-paste(wb1[ind,1],"I",sep="")
}

#Formatting Date
wb1[,2]<-format(as.Date(wb1[,2],"%d-%b-%Y"),"%Y%m%d")

#Writing to text file
out_file<-paste("../Output-Files/fo",today,".txt",sep="")
write.table(wb1,file=out_file,sep=",",quote=FALSE,row.names=FALSE,col.names=FALSE)
return(s)
}

eod_fo_range<-function(fromdate,todate)
{
	cur_date<-fromdate
	failed<-0
	while(cur_date<=todate)
	{
		status<-eod_fo(cur_date)
		if(!identical(status,"200"))
		{failed<-failed+1}
		else
		{
			
		}
		cur_date<-cur_date+1
	}
	return(failed)
}
