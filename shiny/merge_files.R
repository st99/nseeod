merge_files<-function(input)
{
	unlink("../Others/*.*")
	tar_date<-input$tar_date_from
	while(!identical(tar_date,input$tar_date_to+1)){
	today<-format(tar_date,"%Y-%m-%d")
	
	#file_name used further too create the actual merged file
	file_name<-paste("../Output-Files/",today,"-NSE.txt",sep="")
	if(file.exists(file_name))
		unlink(file_name);
	file_list<-list.files("../Output-Files",full.names=TRUE,pattern=today)
	file_len<-0
	if(input$ind)
		file_len<-file_len+1
	if(input$eq)
		file_len<-file_len+1	
	if(input$fo)
		file_len<-file_len+1

	if((length(file_list)==file_len&&identical(input$dnld_type,"part"))||(length(file_list)==3&&identical(input$dnld_type,"all")))
	{
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
		write.table(dataset,file_name,row.names=FALSE,col.names=FALSE,sep="\n",quote=FALSE)
	}
	unlink(file_list)
	tar_date<-tar_date+1
	}
return(0)
}