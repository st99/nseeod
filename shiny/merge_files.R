merge_files<-function(input)
{
	unlink("../Others/*.*")
#	unlink("../Output-Files/output.txt")
	tar_date<-input$tar_date_from
	while(!identical(tar_date,input$tar_date_to+1)){
	today<-format(tar_date,"%Y-%m-%d")
	file_list<-list.files("../Output-Files",full.names=TRUE,pattern=today)
#	file_list<-paste("../Output-Files",file_list,sep="")
#	all_data_frames<-lapply(file_list,read.table)
	for (file in file_list){
 
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.table(file, sep="\n")
	next
  }
   
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <-read.table(file, sep="\n")
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
  }
}
	if(length(file_list)==3)
	{
		file_name<-paste("../Output-Files/",today,"-NSE.txt",sep="")
		write.table(dataset,file_name,row.names=FALSE,col.names=FALSE,sep="\n",quote=FALSE)
	}
	unlink(file_list)
	tar_date<-tar_date+1
	}
return(0)
}