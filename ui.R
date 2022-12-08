library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
    
    # Application title
    titlePanel("BLACKJACK SIMULATOR"),
    
    
    sidebarLayout(
      sidebarPanel(
        headerPanel("At This Casino:"),
        helpText("Balckjack pays 2:1"),
        helpText("Dealer hits when dealer total is less than player total"),
        helpText("Wagers can range from: 10 to 10,000 "),
        helpText("To begin play: Sit at the table and start new hand"),
        helpText("After the round is over, start a new hand again"),
        helpText("The number under your balance is how many games have been played"),
        helpText("The number under your hand is how many times you have hit"),
        selectInput('decks', 'Enter how many decks you want to play with', choices = c(5, 6, 8), selected = 5),
        numericInput('starting_bal', "Starting Balance:", min =0, max = 1000000, value =10000),
        numericInput('wager', "Wager:", min =10, max = 10000, value =10),
        actionButton('sit', label = 'Sit Down at Table', width = '150px', style = "color: #fff; background-color: #951F97; border-color: #2e6da4"),
        
        actionButton('start', label = 'Start New Hand', width = '150px', style = "color: #fff; background-color: #337ab7; border-color: #2e6da4"),
        actionButton('hit', label = 'Hit', width = '200px', height = '250px', style = "color: #fff; background-color: #85bb65; border-color: #2e6da4"),
        actionButton('stand', label = 'Stand', width = '200px', height = '250px', style = "color: #fff; background-color: #ff9900; border-color: #2e6da4"),
        
        headerPanel(" "),
        headerPanel(" "),
        headerPanel(" "),
        headerPanel(" "),
        headerPanel(" "),
        headerPanel(" "),
        headerPanel(" "),
        headerPanel(" "),
        actionButton('leave', label = 'Leave the Table', width = '200px',  style = "color: #fff; background-color: #a10512; border-color: #2e6da4")),
      
      
      mainPanel(
        textOutput("bal"),
        textOutput("hand_num"),
        headerPanel(" "),
        headerPanel(" "),
        headerPanel(" "),
        textOutput("cards"),
        textOutput("hit_cnt"),
        textOutput("Dealer_hand")
      )
    )
  )
)
