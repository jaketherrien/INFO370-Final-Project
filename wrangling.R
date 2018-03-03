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

#all funding data together
funding.data

#writing to .csv
write.csv(funding.data, file = "Data/funding_data_all_years.csv")

#wrangle the test score data
library(tidyr)
score.data = read.csv(file="Data/scores_data.csv", header=TRUE, sep=",", check.names=F)
gathered.score.data = gather(score.data, "year", "score", 2:7)
write.csv(gathered.score.data, file = "Data/score_data_formatted.csv")

#normalize the scores
gathered.score.data$score    <- ifelse(gathered.data$year == '1995' | gathered.data$year == '2000', gathered.data$score/1600, gathered.data$score)
gathered.score.data$score    <- ifelse(gathered.data$year == '2005' | gathered.data$year == '2010' | gathered.data$year == '2013' | gathered.data$year == '2014', gathered.data$score/2400, gathered.data$score)

#formatting funding data "States" to match score data
funding.data$State[funding.data$State == "National" | funding.data$State == "      National Total" | funding.data$State == "Total" | funding.data$State == "     Total"] <- "United States"

#merge/join the data
all.data = merge(funding.data, gathered.score.data, by=c("State","year"))







