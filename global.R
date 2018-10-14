libraries = c("shiny", "shinythemes", "ggplot2", "plyr", "RColorBrewer")

# uncomment these two lines when running for the first time
# install.packages(libraries)
# lapply(libraries, require, character.only = TRUE, warn.conflicts = FALSE, quietly = TRUE)

data = read.csv("data/BestAlbums.csv")

decade_data = data
decade_data$decade = decade_data$Year - decade_data$Year %% 10
decade_data = ddply(decade_data, c("decade", "Artist", "Genre"), summarise, n = length(Album))
