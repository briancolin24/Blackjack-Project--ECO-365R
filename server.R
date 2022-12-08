library(tidyverse)
library(shiny)
#clubs = c("A",2,3,4,5,6,7,8,9,10,"J","Q","K")
#hearts = c("A",2,3,4,5,6,7,8,9,10,"J","Q","K")
#spades = c("A",2,3,4,5,6,7,8,9,10,"J","Q","K")
#diamonds = c("A",2,3,4,5,6,7,8,9,10,"J","Q","K")

#Deck = data.frame(clubs, hearts, spades, diamonds)
s = map(c("C","H","S","D"), function(suit) paste(c("A", 2:10, "J","Q","K"), suit)) %>% unlist()
hand <- as.character()

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  observeEvent(input$sit,{
    hand_num <<-0
    bal <<- input$starting_bal
    wager <<- input$wager
    output$bal <- renderText({scales::dollar(bal, accuracy = 1)})
  })
  
  observeEvent(input$leave,{
    updateNumericInput(
      session = getDefaultReactiveDomain(),
      "starting_bal",
      value = bal
    )
    
    output$cards <- NULL
    output$hit_cnt <- NULL
    output$Dealer_hand <- NULL
    output$bal <- NULL
  })
  
  observeEvent(input$start,{
    bal <<- bal - wager
    hit_num <<- 0
    hand_num <<- hand_num + 1
    deck <<- sample(rep(s,1))
    Dealer_hand <<- deck[1:2]
    deck <<- deck[3:length(deck)]
    hand <<- deck[1:2]
    deck <<- deck[3:length(deck)]
    
    val <<-substr(hand, 0,str_locate(hand," ")-1)
    val <<- sum(replace_na(as.integer(str_replace(val, "A","11")), 10))
    Dealer_val <<-substr(Dealer_hand, 0,str_locate(Dealer_hand," ")-1)
    Dealer_val <<- sum(replace_na(as.integer(str_replace(Dealer_val, "A","11")), 10))
    
    if(val==21){showModal(modalDialog("Blackjack! You Win!", easyClose = T))
      bal <<- bal + wager *3}
    if(Dealer_val==21){showModal(modalDialog("Dealer Blackjack!", easyClose = T))}
    
    output$cards  <<- renderText({paste("Player Hand:",paste(paste(hand, collapse =","), val, sep = "; Score: "))})
    output$hit_cnt  <- renderText({hit_num})
    output$Dealer_hand <<- renderText({paste("Dealer hand:",paste(paste(Dealer_hand, collapse = ","), Dealer_val, sep = "; Score: "))})
    output$bal <- renderText({scales::dollar(bal, accuracy = 1)})
    output$hand_num <- renderText({hand_num})
  })
 #observe events
  observeEvent(input$hit,{
    hit_num <<- hit_num + 1
    #hands[[i]][2+hit_num] <<- deck[1]
    hand <<- c(hand, deck[1])
    deck <<- deck[2:length(deck)]
    
    val <<-substr(hand, 0,str_locate(hand," ")-1)
    val <<- sum(replace_na(as.integer(str_replace(val, "A","11")), 10))
    ########## BUST IF PLAYER HAND >21############
    ########## DEALER PLAYS (AUTO) WHEN BUST APPEARS OR STAND IS SELECTED########
    if(val==21){showModal(modalDialog("Blackjack!", easyClose = T))
      bal <<- bal + wager *3}
    if(val>21){showModal(modalDialog("Bust!", easyClose = T))
    }
    output$cards  <-  renderText({paste(paste(hand, collapse =","), val, sep = "; Score: ")})
    #### Limit so you can't hit when you have 17+ ########
    output$hit_cnt  <- renderText({hit_num})
    output$bal <- renderText({scales::dollar(bal, accuracy = 1)})
  })
  
  observeEvent(input$stand,{
    for(i in 1:10){
      if(Dealer_val<21 & Dealer_val < val){
        Dealer_hand <<- c(Dealer_hand, deck[1])
        deck <<- deck[2:length(deck)]
        
        Dealer_val <<-substr(Dealer_hand, 0,str_locate(Dealer_hand," ")-1)
        Dealer_val <<- sum(replace_na(as.integer(str_replace(Dealer_val, "A","11")), 10))
        
        if(Dealer_val==21){showModal(modalDialog("Dealer Blackjack! You Lose!", easyClose = T))}
        if(Dealer_val>21){showModal(modalDialog("Dealer Bust! You Win!", easyClose = T))
          bal <<- bal + wager *2}
        if(Dealer_val>val & Dealer_val <=21){showModal(modalDialog("Dealer Wins!", easyClose = T))}
        output$Dealer_hand <<- renderText({paste(paste(Dealer_hand, collapse = ","), Dealer_val, sep = "; Score: ")}) 
        output$bal <- renderText({scales::dollar(bal, accuracy = 1)})
      } else if(Dealer_val<21 & Dealer_val == val){
        showModal(modalDialog("Push!", easyClose = T))
        bal <<- bal + wager
      }
    }
    
  })
  
})



