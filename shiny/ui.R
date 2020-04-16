library(shiny)
source("eod.r")
source("eodeq.r")
source("eodfo.r")

ui <- fluidPage(shinyjs::useShinyjs(),
		titlePanel("NSE EOD Data Downloader"),
		sidebarLayout(
			sidebarPanel(
				dateInput(inputId="tar_date_from", label="Select FROM date",value=Sys.Date(),max=Sys.Date()),
				dateInput(inputId="tar_date_to", label="Select TO date",value=Sys.Date(),max=Sys.Date()),
				radioButtons("dnld_type","",c("ALL"="all","PARTIAL"="part"),inline=TRUE),
				checkboxInput(inputId="ind",label="Indices"),
				checkboxInput(inputId="eq",label="Equity"),
				checkboxInput(inputId="fo",label="F&O"),
				actionButton(inputId="goButton",label="Submit")
			),
			mainPanel(
				h3("File Status"),
				verbatimTextOutput("download_status"),
				verbatimTextOutput("indices_status_output"),
				verbatimTextOutput("equity_status_output"),
				verbatimTextOutput("fo_status_output")


			)
		)
	)

