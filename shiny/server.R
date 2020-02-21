library(shiny)
source("eod.r")
source("eodeq.r")
source("eodfo.r")
source("merge_files.r")

server <- function(input,output,session)
{
	download_files<-eventReactive(input$goButton,{
		if(input$ind){
		indices_status<-(eod_indices_range(input$tar_date_from,input$tar_date_to))
			output$indices_status_output<-renderText(paste0("Indices files downloaded successfully. Files for ",indices_status," dates not found."))
		}
		else
			output$indices_status_output<-renderText(paste0("Indices Files skipped."))

		if(input$eq){
		equity_status<-(eod_equity_range(input$tar_date_from,input$tar_date_to))
			output$equity_status_output<-renderText(paste0("Equity files downloaded successfully. Files for ",equity_status," dates not found."))
		}
		else
			output$equity_status_output<-renderText(paste0("Equity Files skipped."))
	
		if(input$fo){
		fo_status<-(eod_fo_range(input$tar_date_from,input$tar_date_to))
			output$fo_status_output<-renderText(paste0("FO files downloaded successfully. Files for ",fo_status," dates not found."))
		}
		else
			output$fo_status_output<-renderText(paste0("FO Files skipped."))
	
		merge_files(input)
		paste0("Files downloaded for period ",input$tar_date_from," to ",input$tar_date_to,".")
	})

	output$download_status<-renderText(
		download_files()
	)
	#observeEvent(indices_file(),{merge_files()})
	
    	session$onSessionEnded(function() {
        stopApp()
    })
}
	 
