
#Install necessary packages if they are not already installed

install.packages("dplyr")
install.packages("pxR")
install.packages("ggplot2")
install.packages("tidyr")

# Load necessary packages
library(dplyr)
library(pxR)
library(ggplot2)
library(tidyr)

# This r code was created on 2026-01-07 to accompany a release on 2026-01-21

# Set working directory to source file location
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read in px file
All.px <- read.px("GMSA04.px")

#Explore the px file metadata
All.px$TITLE
All.px$VALUES$Statistic
All.px$CODES$Anatomical.Therapeutic.Chemical.3
All.px$VALUES$Anatomical.Therapeutic.Chemical.3
All.px$VALUES$Anatomical.Therapeutic.Chemical.1

#Convert to dataframe to work with Dplyr
All.DF <- as.data.frame(All.px)

# View the DF
View(All.DF)

# YOu can ignore this code
# All.DF$HSE.Health.Regions <- "Ireland"

#Filter the dataframe for only what we're interested in
All.DF.Filtered <- All.DF%>%filter(Statistic == "Percentage of persons receiving an item from ATC1 that also received an item from ATC3" &
                                  Sex == "All sexes" &
                                  Age.Group == "All ages"&
                                  Anatomical.Therapeutic.Chemical.1 ==  "All anatomical therapeutic chemical substances" &
                                  Anatomical.Therapeutic.Chemical.3 ==  "Antidepressants (N06A)" &
                                  HSE.Health.Regions == "Ireland"
                                  )%>%dplyr::select(Anatomical.Therapeutic.Chemical.3, Year, value)

# View the resulting dataframe
View(All.DF.Filtered)

# Convert Year from factor to numeric for plotting
All.DF.Filtered$Year <- as.numeric(as.character(All.DF.Filtered$Year))


#plot the data
ggplot(All.DF.Filtered, aes(x = Year, y = value)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Changes in Percentage of Active Persons receiving Antidepressants over time",
    x = "Year",
    y = "%"
  ) +
  theme_classic()

# Save Plot
ggsave(filename = "Plot.jpeg",
       width = 6,   #inches
       height = 4, #inches
       dpi = 300)   #resolution

