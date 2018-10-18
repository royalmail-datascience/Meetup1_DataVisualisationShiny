source("global.R")

server = function(input, output) {

######################################################################
# first tab panel - HOME

datatoplot = reactive({
    datatoplot = subset(data, Year >= input$daterange[1] & Year <= input$daterange[2])
})
  
output$header = renderText({
  paste("Data overview")
  })

output$summary = renderText({
  datatoplot = datatoplot()
  paste0("This dataset contains data from ", min(datatoplot$Year), " to ", max(datatoplot$Year),  
         ". \nContains ", length(unique(datatoplot$Album)), " albums",
         ". \nIncludes ", length(unique(datatoplot$Artist)), " artists and ", length(unique(datatoplot$Genre)), " musical genres.", sep = "")
})

output$data = renderDataTable({
  data = datatoplot()
  data = data[order(data$Number), ]
})
  
output$topalbums = renderPlot({
  datatoplot = datatoplot()
  
  variable = input$checkGroup
  if (variable == 1){
    variable_name = "Artist"
  } else if (variable == 2){
    variable_name = "Genre"
  } else if (variable == 3){
    variable_name = "Year"
  }
  
  datatoplot = ddply(datatoplot, c(variable_name), summarise, n = length(Number))
  topdata = datatoplot[order(-datatoplot$n),]
  topdata = topdata[1:10,]
  topdata$n = as.factor(topdata$n)
  n = "n"
  
  ggplot(topdata) + 
    geom_bar(aes_string(variable_name, n), stat = "identity", colour = "black", fill = "#009E73") +
    xlab(variable_name) + ylab("Number of Albums") + 
    ggtitle(paste0("Top 10 ", variable_name, "\n")) +
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 16, face = "bold"), 
          title = element_text(size = 18), axis.text.x = element_text(angle = 45, hjust = 1))
})

# end of first tab panel
######################################################################


######################################################################
# second tab panel - ARTIST VIEW

myfavouriteartist = eventReactive(input$update, {
  myfavouriteartist = subset(data, Artist == input$selectartist)
})

output$artisttimeline = renderPlot({
  datatoplot = myfavouriteartist()
  ggplot(datatoplot, aes(as.factor(Year), as.factor(Number), group = 1)) + 
    geom_point(size = 2) + 
    geom_line(size = 1)+
    xlab("Year") + ylab("Album ranking") +
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 18, face = "bold"))
})

output$artistdata = renderDataTable({
  myfavouriteartist()
})

# end of second tab panel
######################################################################


######################################################################
# third tab panel - TIME SERIES ANALYSIS

output$genres = renderPlot({
  datatoplot = ddply(decade_data, c("decade", "Genre"), summarise, n = sum(n))
  datatoplot_genre = ddply(datatoplot, c("decade"), summarise, n = length(Genre))
  datatoplot_total = ddply(decade_data, c("decade"), summarise, total = sum(n))
  datatoplot_mix = merge(datatoplot_genre, datatoplot_total, by = "decade")
  
  ggplot(datatoplot_mix) + 
    geom_bar(aes(decade, total), stat = "identity", fill = "#56B4E9", colour = "black") +
    geom_line(aes(decade, n), size = 1) +
    geom_point(aes(decade, n), size = 1) +
    xlab("Decade") + ylab("Number of Albums") +
    ggtitle("\n Total number of albums vs different genres per decade \n") +
    scale_x_continuous(breaks = seq(1950, 2010, 10)) +
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 16, face = "bold"), title = element_text(size = 18))
})

output$yearsgenre = renderPlot({
  datatoplot = ddply(decade_data, c("decade", "Genre"), summarise, n = sum(n))
  datatoplot$bin = cut(datatoplot$n, c(0, 1, 2, 4, 10, 40, 200))
  
  ggplot(datatoplot, aes(Genre, decade)) + geom_tile(aes(fill = bin), colour = "black") +
    scale_y_continuous(breaks = seq(1950, 2010, by = 10)) +
    xlab("Genre") + ylab("Decade") +
    scale_fill_manual(name = "Number of Albums", values = brewer.pal(n = 6, name = "YlGnBu")) +
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 16, face = "bold"), 
          legend.title = element_text(size = 16, face = "bold"), legend.text = element_text(size = 16), 
          axis.text.x = element_text(angle = 45, hjust = 1))
})

output$artists = renderPlot({
  datatoplot = ddply(decade_data, c("decade", "Artist"), summarise, n = sum(n))
  datatoplot_artist = ddply(datatoplot, c("decade"), summarise, n = length(Artist))
  datatoplot_total = ddply(decade_data, c("decade"), summarise, total = sum(n))
  datatoplot_mix = merge(datatoplot_artist, datatoplot_total, by = "decade")

  ggplot(datatoplot_mix) + 
    geom_bar(aes(decade, total), stat = "identity", fill = "#56B4E9", colour = "black") +
    geom_line(aes(decade, n), size = 1) +
    geom_point(aes(decade, n), size = 1) +
    xlab("Decade") + ylab("Number of Albums") +
    ggtitle("\n Total number of artists vs different artists per decade \n") +
    scale_x_continuous(breaks = seq(1950, 2010, 10)) +
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 16, face = "bold"), title = element_text(size = 18))
})

output$yearsartist = renderPlot({
  datatoplot = ddply(decade_data, c("decade", "Artist"), summarise, n = sum(n))
  datatoplot = subset(datatoplot, n > 1)
  
  ggplot(datatoplot, aes(Artist, decade)) + geom_tile(aes(fill = as.factor(n)), colour = "black") +
    scale_y_continuous(breaks = seq(1950, 2010, by = 10)) +
    xlab("Artist") + ylab("Decade") +
    scale_fill_manual(name = "Number of Albums", values = brewer.pal(n = 6, name = "YlGnBu")) +
    theme(axis.text = element_text(size = 14), axis.title = element_text(size = 16, face = "bold"), 
          legend.title = element_text(size = 16, face = "bold"), legend.text = element_text(size = 16), 
          axis.text.x = element_text(angle = 45, hjust = 1))
})


# end of third tab panel
######################################################################

} # server
