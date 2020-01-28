library(shiny)
source("eod.r")
source("eodeq.r")
source("eodfo.r")
source("merge_files.r")

server <- function(input,output,session)
{
	reactiveVal
	observeEvent(input$goButton,{
		if(input$ind){
		indices_status<-(eod_indices_range(input$tar_date_from,input$tar_date_to))
		if(identical(indices_status,0))
			output$indices_status_output<-renderText(paste0("Indices files downloaded successfully for dates from ",input$tar_date_from," to ",input$tar_date_to))
		else
			output$indices_status_output<-renderText(paste0("Error downloading ",indices_status," indices files."))
		}
		else
			output$indices_status_output<-renderText(paste0("Indices Files skipped."))

		if(input$eq){
		equity_status<-(eod_equity_range(input$tar_date_from,input$tar_date_to))
		if(identical(equity_status,0))
			output$equity_status_output<-renderText(paste0("Equity files downloaded successfully for dates from ",input$tar_date_from," to ",input$tar_date_to))
		else
			output$equity_status_output<-renderText(paste0("Error downloading ",equity_status," equity files."))
		}
		else
			output$equity_status_output<-renderText(paste0("Equity Files skipped."))
	
		if(input$fo){
		fo_status<-(eod_fo_range(input$tar_date_from,input$tar_date_to))
		if(identical(fo_status,0))
			output$fo_status_output<-renderText(paste0("F&O files downloaded successfully for dates from ",input$tar_date_from," to ",input$tar_date_to))
		else
			output$fo_status_output<-renderText(paste0("Error downloading ",fo_status," F&O files."))
		}
		else
			output$fo_status_output<-renderText(paste0("FO Files skipped."))
	
		merge_files()
	})

	
	#observeEvent(indices_file(),{merge_files()})
	
    	session$onSessionEnded(function() {
        stopApp()
    })
}
	 
