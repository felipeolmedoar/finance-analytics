##Import and data preparation


#----Set date range

START_DATE <- "2019-07-31"
END_DATE   <- "2020-08-01"

#----Importing IPSA companies (2020) and IPSA index according to date (https://es.investing.com/indices/ipsa-historical-data)

#IPSA companies
IPSA_STOCKS <- read_excel("data/IPSA_Stock_2020.xlsx", range = "A1:A30", col_names = F) %>% 
               .[[1]] %>%
               paste0(".SN")

#IPSA Close price
SP_CLX_IPSA <- read_excel("data/IPSA_Historico_1Year.xlsx") %>%
               data_wrangling_IPSA()

#---- Importing stock data 

my_data <- importing_data(IPSA_STOCKS, START_DATE, END_DATE) %>% 
           data_wrangling()


##Returns


#----Daily return

#Stocks

close_prices <- select(my_data, -DATE)

stock_return <- cbind(my_data[-1,1], apply(close_prices, 2, function(x) log(diff(x)/head(x,-1)+1)))

#IPSA

IPSA_return <- cbind(SP_CLX_IPSA[-1,1], apply(select(SP_CLX_IPSA, -DATE), 2, function(x) log(diff(x)/head(x,-1)+1)))

#----Cumulative return

#Stocks

CUM_RETURN_1Y <- cumulative_return(stock_return, START_DATE)

STOCK_NAMES <- colnames(CUM_RETURN_1Y)[2:ncol(CUM_RETURN_1Y)]

#IPSA

IPSA_CUM_RETURN_1Y <- cumulative_return(IPSA_return, START_DATE)

#----Changing data format (for datasetInput2 on server.R)

CUM_RETURN_1Y_melt <- melt(CUM_RETURN_1Y,id.vars = "DATE", measure.vars =STOCK_NAMES)


