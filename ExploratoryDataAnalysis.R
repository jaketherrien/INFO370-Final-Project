#install.packages("maps")
library(dplyr)
library(maps)
scores = read.csv("Data/scores_data.csv", stringsAsFactors = F)
scores = scores %>% mutate(sum = X1995 + X2000 + X2005 + X2010 + X2013 + X2014)

# On average, the lowest SAT scores are from the District of Columbia
min.mean = scores %>% filter((sum) == min(sum)) %>% select (-sum)

# On average, the highest SAT scores are from North Dakota
max.mean = scores %>% filter((sum) == max(sum)) %>% select (-sum)

us.scores = scores %>% filter(State != "District of Columbia" & State != "United States")

# This map of the United States shows the average SAT scores by state. 
# The darker the state the lower the average score and vice versa.
tmp <- map('state',plot=FALSE,namesonly=TRUE)
tmp <- match(gsub('(:.*)','',tmp),tolower(state.name))
colors = (us.scores$sum - min(us.scores$sum)) / (max(us.scores$sum) - min(us.scores$sum))
map('state',fill=TRUE,col= gray(colors)[tmp])
