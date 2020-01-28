merge_files<-function()
{
	unlink("../Others/*.*")
	unlink("../Output-Files/output.txt")
	file_list<-list.files("../Output-Files",full.names=TRUE)
#	file_list<-paste("../Output-Files",file_list,sep="")
#	all_data_frames<-lapply(file_list,read.table)
	for (file in file_list){
       
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.table(file, sep="\n")
  }
   
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <-read.table(file, sep="\n")
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
  }
}
	unlink("../Output-Files/*.*")
	write.table(dataset,"../Output-Files/output.txt",row.names=FALSE,col.names=FALSE,sep="\n",quote=FALSE)
	return(0)
}