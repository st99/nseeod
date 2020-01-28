library(shiny)
source("eod.r")
source("eodeq.r")
source("eodfo.r")
source("merge_files.r")

server <- function(input,output,session)
{
	indices_file<-eventReactive(input$goButton,{
		if(input$ind){
		indices_status<-(eod_indices_range(input$tar_date_from,input$tar_date_to))
		if(identical(indices_status,0))
			paste0("Indices files downloaded successfully for dates from ",input$tar_date_from," to ",input$tar_date_to)
		else
			paste0("Error downloading ",indices_status," indices files.")
		}
		else
			paste0("Indices Files skipped.")
	})
	
	equity_file<-eventReactive(input$goButton,{
		if(input$eq){
		equity_status<-(eod_equity_range(input$tar_date_from,input$tar_date_to))
		if(identical(equity_status,0))
			paste0("Equity files downloaded successfully for dates from ",input$tar_date_from," to ",input$tar_date_to)
		else
			paste0("Error downloading ",equity_status," equity files.")
		}
		else
			paste0("Equity Files skipped.")
	})

	fo_file<-eventReactive(input$goButton,{
		if(input$fo){
		fo_status<-(eod_fo_range(input$tar_date_from,input$tar_date_to))
		if(identical(fo_status,0))
			paste0("F&O files downloaded successfully for dates from ",input$tar_date_from," to ",input$tar_date_to)
		else
			paste0("Error downloading ",fo_status," F&O files.")
		}
		else
			paste0("FO Files skipped.")
	})

	output$indices_status_output<-renderText({
		indices_file()
	})

	output$equity_status_output<-renderText({
		equity_file()	
	})

	output$fo_status_output<-renderText({
		fo_file()	
	})
	
	#observeEvent(indices_file(),{merge_files()})
	eventReactive	
	
    	session$onSessionEnded(function() {
        stopApp()
    })
}
	 
