library("shiny")
source("global.R")

ui = fluidPage(theme = shinytheme("flatly"),
  
  navbarPage(title = "Rolling Stone best albums of all time",
             tabPanel(title = "Home", value = "home", 
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("daterange", label = h3("Select a year range"), 
                                      min = min(data$Year), max = max(data$Year), 
                                      value = c(min(data$Year), max(data$Year)), sep = "", step = 1), 
                          br(), br(),
                          h3(textOutput("header")),
                          br(), br(),
                          textOutput("summary"),
                          br(), br(),
                          radioButtons("checkGroup", label = h3("X-axis variable"), 
                                             choices = list("Artist" = 1, "Genre" = 2, "Year" = 3),
                                             selected = 1)
                        ), #sidebar panel
                        mainPanel(
                          plotOutput("topalbums"), 
                          br(), br(), 
                          dataTableOutput("data")
                        ) #mainpanel
                      ) #sidebarlayout
             ), #first tabpanel
             tabPanel(title = "Artist view", value = "artistview",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("selectartist", 
                                         label = h3("Select your favourite Artist"), 
                                         choices = sort(unique(data$Artist)), 
                                         selected = NULL, 
                                         multiple = FALSE,
                                         selectize = TRUE), 
                          br(), br(),
                          actionButton("update", "Update Artist"),
                          br(), br()
                        ), #sidebarpanel
                      mainPanel(
                        plotOutput("artisttimeline"),
                        br(), br(), 
                        dataTableOutput("artistdata")
                      ) #mainpanel
                    ) #sidebarlayout
             ), #second tabpanel
             tabPanel(title = "Time series analysis", value = "time",
                      mainPanel(
                        tabsetPanel(
                          tabPanel("Genres", 
                               plotOutput("genres")),
                          tabPanel("Genre evolution", 
                               plotOutput("yearsgenre", width = "1500px", height = "700px")), 
                          tabPanel("Artists", 
                                   plotOutput("artists")),
                          tabPanel("Artist evolution", 
                                   plotOutput("yearsartist", width = "1500px", height = "700px"))
                        ) #tabsetpanel
                      ) #mainpanel
             ) #third tabpanel
  ) #navbar page
) #fluid page



