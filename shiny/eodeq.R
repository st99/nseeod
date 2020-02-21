eod_equity<-function(tar_date){
library(tibble)
library(sys)
library(curl)

#Preparing URL string for download
#today<-toupper(format(Sys.Date()-3,"%d%b%Y"))
today<-toupper(format(tar_date,"%d%b%Y"))
downloadstr<-"https://archives.nseindia.com/content/historical/EQUITIES/2020/JAN/cm10JAN2020bhav.csv.zip"
substr(downloadstr,nchar(downloadstr)-20,nchar(downloadstr)-12)<-today
substr(downloadstr,nchar(downloadstr)-26,nchar(downloadstr)-24)<-substr(today,3,5)
substr(downloadstr,nchar(downloadstr)-31,nchar(downloadstr)-28)<-substr(today,6,9)

#Comment this line when files for latest date available
#downloadstr<-"https://archives.nseindia.com/content/historical/EQUITIES/2020/JAN/cm10JAN2020bhav.csv.zip"
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

wb1<-wb1[wb1$SERIES=="EQ"|wb1$SERIES=="BE",]
#Reordering Columns
wb1<-wb1[,c(1,11,3,4,5,6,9)]

#Adding Open Interest Column
wb1["Open.Interest"]<-0

#Replacing empty cells with 0
wb1<-sapply(wb1,as.character)
wb1[wb1=="-"]<-"0"

#Formatting Index name
wb1[,1]<-toupper(wb1[,1])
wb1[,1]<-gsub(' ','',wb1[,1])

#Formatting Date
wb1[,2]<-format(as.Date(wb1[,2],"%d-%b-%Y"),"%Y%m%d")

#Writing to text file
today<-format(tar_date,"%Y-%m-%d")
out_file<-paste("../Output-Files/",today,"-NSE-EQ.txt",sep="")
write.table(wb1,file=out_file,sep=",",quote=FALSE,row.names=FALSE,col.names=FALSE)
return(s)
}

eod_equity_range<-function(fromdate,todate)
{
	cur_date<-fromdate
	failed<-0
	while(cur_date<=todate)
	{
		status<-eod_equity(cur_date)
		if(!identical(status,"200"))
		{failed<-failed+1}
		else
		{
			
		}
		cur_date<-cur_date+1
	}
	return(failed)
}
