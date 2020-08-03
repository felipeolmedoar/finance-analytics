######## Global environment and functions ########


##Packages

#Install these packages if you don't have them
# install.packages("tidyverse")
# install.packages("quantmod")
# install.packages("lubridate")
# install.packages("readxl")
# install.packages("plotly")
# install.packages("shiny")
# install.packages('rsconnect')
# install.packages("reshape2")
# install.packages("shinydashboard")
# install.packages("shinyWidgets")

library("tidyverse")
library("lubridate")
library("quantmod")
library("readxl")
library("plotly")
library("shiny")
library("rsconnect")
library("reshape2")
library("shinydashboard")
library("shinyWidgets")



##Functions


#----Scraping 'CLOSE PRICE' from Yahoo Finance

importing_data <- function(stock_names, date_from, date_to){

  data0 <- quantmod::getSymbols(stock_names[1], from=date_from, to=date_to, src = "yahoo", auto.assign = F)[,paste0(stock_names[1],".Close")]
  new_data <- matrix(0, nrow(data0), length(stock_names)-1)

  for (i in 1:(length(stock_names)-1)){
    new_data[,i] <- as.vector(quantmod::getSymbols(stock_names[i+1], from=date_from, to=date_to, src = "yahoo", auto.assign = F)[,paste0(stock_names[i+1],".Close")])
  }

  data <- cbind(data0, new_data)
  colnames(data) <- stock_names

  return(data) #matrix: nº trading days x nª stocks

}

#----Data preparation

data_wrangling <- function(data){

  stocks_names <- colnames(data)

  #Date to column an transforming to tibble

  data <- data %>%
    as.data.frame() %>%
    rownames_to_column("DATE") %>%
    as_tibble()

  #Changing date format

  data$DATE <- as.Date(data$DATE, format="%Y-%m-%d")
  data <- data %>%
    select(DATE, everything())

  colnames(data) <- c("DATE", gsub(".SN","",stocks_names)) #PARAMETRIZAR

  return(data)

}

data_wrangling_IPSA <- function(my_SP_CLX_IPSA){

  colnames(my_SP_CLX_IPSA)[1:2] <- c("DATE", "IPSA")

  my_SP_CLX_IPSA <- my_SP_CLX_IPSA %>%
    select(DATE, IPSA)

  my_SP_CLX_IPSA$DATE <- as.Date(my_SP_CLX_IPSA$DATE, "%d.%m.%Y")

  my_SP_CLX_IPSA$IPSA <- gsub("\\.","",my_SP_CLX_IPSA$IPSA) %>%
    gsub(",",".",.) %>% as.numeric()

  my_SP_CLX_IPSA<- my_SP_CLX_IPSA[nrow(my_SP_CLX_IPSA):1,]

  return(my_SP_CLX_IPSA)
}

#----Cumulative return by date

#Sub_function
cumulative_return_by_date <- function(cum_stock_return_matrix, start_date){
  #MCSR = cum_stock_return_matrix
  filter_data <- cum_stock_return_matrix %>%
    filter(between(DATE, as.Date(start_date), as.Date(today())))
  return(filter_data)
}

#my_start_date: for filter the cumulative returns from a certain date
cumulative_return <- function(my_stock_return, my_start_date){

  cum_stock_return <- my_stock_return[nrow(my_stock_return):1,]
  cum_stock_return <- cbind(select(cum_stock_return, DATE), apply(select(cum_stock_return, -DATE), 2, cumsum))

  filtered_by_date <- cumulative_return_by_date(cum_stock_return, my_start_date)

  return(filtered_by_date)

}


##Data


source("data/data.R")

