##Shiny UI

ui <- dashboardPage(
  dashboardHeader(title = "Finance Analytics"),
  dashboardSidebar(br(),
                   h4("Performance Analysis"),
                   selectInput(
                     inputId = "stock_name",
                     label = "Choose a IPSA stock:",
                     choices = STOCK_NAMES,
                     selected = "STOCK_NAMES[1]"
                     #selectize = FALSE
                   ),
                   div(style="text-align:center","This selection is for",br(),
                       list(icon = icon("chart-line"),("Cumulative return by stock vs benchmark"))),
                   hr(),
                   h4("Portfolio Analysis"),
                   multiInput(
                     inputId = "id",
                     label = "Choose IPSA stocks:", 
                     choices = STOCK_NAMES,
                     selected = "STOCK_NAMES[1]", width = "400px",
                     options = list(
                       enable_search = FALSE,
                       non_selected_header = "Choose between:",
                       selected_header = "You have selected:"
                     )
                   ),
                   div(style="text-align:center","This selection is for",br(),
                       list(icon = icon("chart-line"),("Cumulative return between stocks"))),
                   hr(),
                   h4("Author"),
                   p(h6("Felipe Olmedo Aravena")),
                   h6(em("felipeolmedoar@gmail.com")),
                   list(icon=icon("linkedin"), tags$a(href="https://www.linkedin.com/in/felipeolmedoar/", "LinkedIn"))
  ),
  dashboardBody(
    em("1. Cumulative return [t]: Sum of daily returns of an asset from a period [t] to price on 31-07-2020 (Without considering dividends and splits)."),
    p(em("2. IPSA: Chilean stock market index composed of the 30 stocks with the highest average annual trading volume in the Santiago Stock Exchange.")),
    h5("*The 3 red dotted lines represent the following events in Chile: Social outbreak, Covid-19 and Withdrawal 10% AFP."),
    p(),
    fluidRow(
      column(width=12,
             box(title = "Cumulative return by stock vs benchmark", height = 470, width=NULL, solidHeader = TRUE, status = "primary",
                 plotlyOutput("ts_plot")
             )
      )
    )
    ,br(),
    fluidRow(
      box(
        title = "Cumulative return between stocks", width = 12, solidHeader = F, status = "primary",background = "navy",
        plotlyOutput("multiple_plot")
      )
    )
  )
)