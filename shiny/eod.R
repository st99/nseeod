eod_indices<-function(tar_date){
library(tibble)
library(sys)
library(curl)
library(tools)

#Preparing URL string for download
#today<-format(Sys.Date()-2,"%d%m%Y")
today<-format(tar_date,"%d%m%Y")
downloadstr<-"https://archives.nseindia.com/content/indices/ind_close_all_03012020.csv"
substr(downloadstr,nchar(downloadstr)-11,nchar(downloadstr)-4)<-today

#Comment this line when files for laatest date available
#downloadstr<-"https://archives.nseindia.com/content/indices/ind_close_all_03012020.csv"
req<-curl_fetch_memory(downloadstr)
s<-as.character(req$status_code)
if(!identical(s,"200")){
	return(s)
}

#Downloading File
tmp<-tempfile()
curl_download(downloadstr,tmp)
wb<-read.csv(tmp)
#curl_download(downloadstr,"indices.csv")
#wb <- read.csv("indices.csv")
wb1<-as_tibble(wb)
if(ncol(wb1)<=1)
{	return("404")}

#Reordering Columns
wb1<-wb1[,c(1,2,3,4,5,6,9)]

#Adding Open Interest Column
wb1["Open.Interest"]<-0

#Replacing empty cells with 0
wb1<-sapply(wb1,as.character)
wb1[wb1=="-"]<-"0"

#Formatting Index name
wb1[,1]<-toupper(wb1[,1])
wb1[,1]<-gsub(' ','',wb1[,1])

#Formatting Date
wb1[,2]<-gsub('-','',as.Date(wb1[,2],"%d-%m-%Y"))

#Writing to text file
today<-format(tar_date,"%Y-%m-%d")
out_file<-paste("../Output-Files/",today,"-NSE-IND.txt",sep="")
write.table(wb1,file=out_file,sep=",",quote=FALSE,row.names=FALSE,col.names=FALSE)
return(s)
}

eod_indices_range<-function(fromdate,todate)
{
	cur_date<-fromdate
	failed<-0
	while(cur_date<=todate)
	{
		status<-eod_indices(cur_date)
		if(!identical(status,"200"))
		{failed<-failed+1}
		else
		{
			
		}
		cur_date<-cur_date+1
	}
	return(failed)
}