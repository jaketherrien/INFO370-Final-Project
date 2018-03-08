# install.packages("maps")
library(dplyr)
library(maps)
library(grDevices)
funding = read.csv("Data/funding_data_all_years.csv", stringsAsFactors = F) %>% select(-X)
colnames(funding)[colnames(funding)=="Mean"] = "Average"
scores = read.csv("Data/scores_data.csv", stringsAsFactors = F)
scores = scores %>% mutate(sum = X1995 + X2000 + X2005 + X2010 + X2013 + X2014)

#convert to numbers
funding$Average = as.numeric(gsub('[$,]', '', funding$Average))
funding$Number.of.districts = as.numeric(gsub('[$,]', '', funding$Number.of.districts))



# On average, the lowest SAT scores are from the District of Columbia
#kable
min.mean = scores %>% filter((sum) == min(sum)) %>% select (-sum)

# On average, the highest SAT scores are from North Dakota
#kable
max.mean = scores %>% filter((sum) == max(sum)) %>% select (-sum)

average.funding.by.state = funding %>% group_by(State) %>% summarise(avg.funding = mean(Average)) %>% filter(!(trimws(State) %in% c("National Total", "National", "Total", "District of Columbia")))

# On average, the state with the least funding is Montana
#kable
min.funding = average.funding.by.state %>% filter(avg.funding == min(avg.funding))

# On average, the state with the most funding is Hawaii
#kable
max.funding = average.funding.by.state %>% filter(avg.funding == max(avg.funding))

us.scores = scores %>% filter(State != "District of Columbia" & State != "United States")

# This map of the United States shows the average SAT scores by state. 
# The darker the state the lower the average score and vice versa.
score.map = function(){
  tmp = map('state',plot=FALSE,namesonly=TRUE)
  tmp = match(gsub('(:.*)','',tmp),tolower(state.name))
  colors = (us.scores$sum - min(us.scores$sum)) / (max(us.scores$sum) - min(us.scores$sum))
  map('state',fill=TRUE,col= gray(colors)[tmp])
}

# This map of the United States shows the average funding by state. 
# The darker the state the less funding they received and vice versa.
funding.map = function(){
  tmp = map('state',plot=FALSE,namesonly=TRUE)
  tmp = match(gsub('(:.*)','',tmp),tolower(state.name))
  
  funding.values = funding %>% group_by(State) %>% summarise(total = mean(Average) * mean(Number.of.districts)) %>% filter(!(trimws(State) %in% c("National Total", "National", "Total", "District of Columbia")))
  colors = (funding.values$total - min(funding.values$total)) / (max(funding.values$total) - min(funding.values$total))
  map('state',fill=TRUE,col= gray(colors)[tmp])
}

