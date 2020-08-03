##Shiny server

server <- shinyServer(
  
  function(input,output){
    
    datasetInput <- reactive({
      CUM_RETURN_1Y %>% select(DATE,input$stock_name) %>%
        cbind(select(IPSA_CUM_RETURN_1Y, -DATE)) %>% 
        melt(id.vars = "DATE")
    })
    
    datasetInput2 <- reactive({
      CUM_RETURN_1Y_melt %>% filter(variable %in% input$id)
    })
    
    #Stocks vs benchmark
    output$ts_plot <- renderPlotly({
      
      dataset <- datasetInput()
      
      p <- ggplot(dataset) +
        geom_line(aes(x=DATE, y=value, color=variable, group = 1,
                      text = paste("Date: ", DATE, "<br>Cum. return: ", round(dataset$`value`, 2)*100, "%")))+
        labs(x="Date", y= paste0("[",input$stock_name, " - IPSA]", " Cumulative Return"),  color="Assets")+
        scale_y_continuous(limits = c(min(dataset$`value`)-0.05, max(dataset$`value`)+0.05),
                           breaks=seq(-2,2,0.05), labels = scales::percent_format(accuracy = 1)) +
        scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
        geom_vline(xintercept = as.numeric(as.Date(c("2019-10-18", "2020-03-03", "2020-07-13"))),
                   col = "red",linetype="dotted", alpha=0.7)+
        theme_light()
      
      #transforming to plotly
      p_plotly <- ggplotly(p, tooltip = "text") %>% style(textposition = "right")
      
      
      return(p_plotly)
      
      
      
    })
    
    #Stocks vs stocks
    output$multiple_plot <- renderPlotly({
      
      dataset2 <- datasetInput2()
      
      validate(
        need(input$id, "Please select a stock")
      )
      
      p <- ggplot(dataset2) +
        geom_line(aes(x=DATE, y=value, color=variable, group = 1,
                      text = paste("Date: ", DATE, "<br>Cum. return: ", round(dataset2$`value`, 2)*100, "%")))+
        labs(x="Date", y="Cumulative return", color="Stocks")+
        scale_y_continuous(limits = c(min(dataset2$`value`)-0.05, max(dataset2$`value`)+0.05),
                           breaks=seq(-2,2,0.05), labels = scales::percent_format(accuracy = 1)) +
        scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
        geom_vline(xintercept = as.numeric(as.Date(c("2019-10-18", "2020-03-03", "2020-07-13"))),
                   col = "red",linetype="dotted", alpha=0.7)+
        theme_light()
      
      #transforming to plotly
      p_plotly <- ggplotly(p,tooltip = "text") %>% style(textposition = "right")
      
      
      return(p_plotly)
    })
    
  })


##Deploy


#deployApp()