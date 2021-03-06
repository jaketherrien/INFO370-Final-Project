#pull in data
funding_1995 = read.csv(file="Data/Funding/1995.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_1996 = read.csv(file="Data/Funding/1996.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_1997 = read.csv(file="Data/Funding/1997.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_1998 = read.csv(file="Data/Funding/1998.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_1999 = read.csv(file="Data/Funding/1999.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2000 = read.csv(file="Data/Funding/2000.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2001 = read.csv(file="Data/Funding/2001.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2002 = read.csv(file="Data/Funding/2002.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2003 = read.csv(file="Data/Funding/2003.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2004 = read.csv(file="Data/Funding/2004.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2005 = read.csv(file="Data/Funding/2005.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2006 = read.csv(file="Data/Funding/2006.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2007 = read.csv(file="Data/Funding/2007.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2008 = read.csv(file="Data/Funding/2008.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2009 = read.csv(file="Data/Funding/2009.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2010 = read.csv(file="Data/Funding/2010.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2011 = read.csv(file="Data/Funding/2011.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2012 = read.csv(file="Data/Funding/2012.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
funding_2014 = read.csv(file="Data/Funding/2014.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)

#adding year column
funding_1995$year <- 1995
funding_1996$year <- 1996
funding_1997$year <- 1997
funding_1998$year <- 1998
funding_1999$year <- 1999
funding_2000$year <- 2000
funding_2001$year <- 2001
funding_2002$year <- 2002
funding_2003$year <- 2003
funding_2004$year <- 2004
funding_2005$year <- 2005
funding_2006$year <- 2006
funding_2007$year <- 2007
funding_2008$year <- 2008
funding_2009$year <- 2009
funding_2010$year <- 2010
funding_2011$year <- 2011
funding_2012$year <- 2012
funding_2014$year <- 2014

#combining all years into one dataframe
funding.data <- do.call("rbind", list(funding_1995, funding_1996, funding_1997, funding_1998, 
                      funding_1999, funding_2000, funding_2001, funding_2002, 
                      funding_2003, funding_2004, funding_2005, funding_2006, 
                      funding_2007, funding_2008, funding_2009, funding_2010, 
                      funding_2011, funding_2012, funding_2014))

#writing to .csv
write.csv(funding.data, file = "Data/funding_data_all_years.csv")

#wrangle the test score data
library(tidyr)
score.data = read.csv(file="Data/scores_data.csv", header=TRUE, sep=",", check.names=F)
gathered.score.data = gather(score.data, "year", "score", 2:7)
write.csv(gathered.score.data, file = "Data/score_data_formatted.csv")

#normalize the scores
gathered.score.data$score    <- ifelse(gathered.score.data$year == '1995' | gathered.score.data$year == '2000', gathered.score.data$score/1600, gathered.score.data$score)
gathered.score.data$score    <- ifelse(gathered.score.data$year == '2005' | gathered.score.data$year == '2010' | gathered.score.data$year == '2013' | gathered.score.data$year == '2014', gathered.score.data$score/2400, gathered.score.data$score)

colnames(funding.data)[colnames(funding.data) == '?..State'] <- 'State'
#formatting funding data "States" to match score data
funding.data$State[funding.data$State == "National" | funding.data$State == "      National Total" | funding.data$State == "Total" | funding.data$State == "     Total"] <- "United States"

#merge/join the data
all.data = merge(funding.data, gathered.score.data, by=c("State","year"))

#convert money to numeric for statistical testing
all.data$Mean = as.numeric(gsub('[$,]', '', all.data$Mean))
all.data$Maximum = as.numeric(gsub('[$,]', '', all.data$Maximum))
all.data$Minimum = as.numeric(gsub('[$,]', '', all.data$Minimum))

#converting funding values to 2014 values, using values from usinflationcalulator.com
all.data$Mean    <- ifelse(all.data$year == '1995', all.data$Mean*1.5534, all.data$Mean)
all.data$Mean    <- ifelse(all.data$year == '2000', all.data$Mean*1.3748, all.data$Mean)
all.data$Mean    <- ifelse(all.data$year == '2005', all.data$Mean*1.2122, all.data$Mean)
all.data$Mean    <- ifelse(all.data$year == '2010', all.data$Mean*1.0857, all.data$Mean)

all.data$Minimum    <- ifelse(all.data$year == '1995', all.data$Minimum*1.5534, all.data$Minimum)
all.data$Minimum    <- ifelse(all.data$year == '2000', all.data$Minimum*1.3748, all.data$Minimum)
all.data$Minimum    <- ifelse(all.data$year == '2005', all.data$Minimum*1.2122, all.data$Minimum)
all.data$Minimum    <- ifelse(all.data$year == '2010', all.data$Minimum*1.0857, all.data$Minimum)

all.data$Maximum    <- ifelse(all.data$year == '1995', all.data$Maximum*1.5534, all.data$Maximum)
all.data$Maximum    <- ifelse(all.data$year == '2000', all.data$Maximum*1.3748, all.data$Maximum)
all.data$Maximum    <- ifelse(all.data$year == '2005', all.data$Maximum*1.2122, all.data$Maximum)
all.data$Maximum    <- ifelse(all.data$year == '2010', all.data$Maximum*1.0857, all.data$Maximum)

#write all data to csv for further analysis 
write.csv(all.data, file = "Data/funding_and_scores.csv")

scatter.smooth(x=all.data$Mean, y=all.data$score, main="mean ~ score")  # scatterplot

# testing to see if correlation cor -0.253 
cor(all.data$Mean, all.data$score)

# Density plot to check that response variable is close to normal, it is :)
# install.packages('e1071', repos = "http://cran.us.r-project.org")
library(e1071)
dev.off()
par(mfrow=c(1, 2))  # divide graph area in 2 columns
plot(density(all.data$score), main="Density Plot: Score", ylab="Frequency", sub=paste("Skewness:", round(e1071::skewness(all.data$score), 2)))  # density plot for 'speed'
polygon(density(all.data$score), col="red")
plot(density(all.data$Mean), main="Density Plot: Mean", ylab="Frequency", sub=paste("Skewness:", round(e1071::skewness(all.data$Mean), 2)))  # density plot for 'dist'
polygon(density(all.data$Mean), col="red")



# Regression to check and see any relation between Score and mean 
linearMod <- lm(score ~ Mean, data=all.data)
summary(linearMod)

# making predictions
preds.w.plim <- predict(lm(all.data$Mean ~ all.data$score), interval="prediction")
preds.w.clim <- predict(lm(all.data$Mean ~ all.data$score), interval="confidence")

#plotting predictions against actual score
plot(predict(linearMod),all.data$score,
     xlab="predicted", ylab="actual")


#testing to see if there's a meaningful relationship between average funding and score
t.test(all.data$Mean, all.data$score)

#run a t-test for data from each year
library(dplyr)
#2014
data.2014 = all.data %>% filter(year == '2014')
t.test(data.2014$Mean, data.2014$score)
#2010
data.2010 = all.data %>% filter(year == '2010')
t.test(data.2010$Mean, data.2010$score)
#2005
data.2005 = all.data %>% filter(year == '2005')
t.test(data.2005$Mean, data.2005$score)
#2000
data.2000 = all.data %>% filter(year == '2000')
t.test(data.2000$Mean, data.2000$score)
#1995
data.1995 = all.data %>% filter(year == '1995')
t.test(data.1995$Mean, data.1995$score)

#running a t-test on Alabama
alabama.data = all.data %>% filter(State == 'Alabama')
t.test(alabama.data$Mean, alabama.data$score)

#running a t-test on California
california.data = all.data %>% filter(State == 'California')
t.test(california.data$Mean, california.data$score)




