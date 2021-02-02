library(tidyverse)
library(gapminder)
#Ved hjælp af betingelser og if else kan vi bestemme vores control-flow, vi styrer, hvad der sker hvornår

# if (condition is true) {
#   perform action
# }
# 
# # if ... else
# if (condition is true) {
#   perform action
# } else {  # that is, if the condition is false,
#   perform alternative action
# }

x <- 8

if (x >= 10) { #Hvis x er større end eller lig med 10
  print("x is greater than or equal to 10") #Udskriv string
} else { #Ellers
  print("x is less than 10") #Udskriv string
}

#Man kan komme flere på med else if
if (x >= 10) {
  print("x is greater than or equal to 10")
} else if (x > 5) {
  print("x is greater than 5, but less than 10")
} else {
  print("x is less than 5")
}

#Det er booleans værdier: Derfor er nedenstående falsk da x er falsk
x  <-  4 == 3
x
if (x) {
  "4 equals 3"
} else {
  "4 does not equal 3"          
}

#Use an if() statement to print
#a suitable message reporting whether there are any records from 2002 in the gapminder dataset.
gapminder[(gapminder$year == 2002),]
rows2002_number <- nrow(gapminder[(gapminder$year == 2002),])
rows2002_number >= 1

if(any(gapminder$year == 2002)){
  print("Record(s) for the year 2002 found.")
}

#If virker kun med vectorer på en længde, hvis dette ikke er tilfældet tager den kun den første værdi.

# ifelse function 
#ifelse(condition is true, perform action, perform alternative action) 

y <- -3
ifelse(y < 0, "y is a negative number", "y is either positive or zero")

#For løkker
#For er svær at benytte, brug den hvis rækkefølgen er vigtig eller brug purr pakken, den er mere effektiv
# for (iterator in set of values) {
#   do a thing
# }

for (i in 1:10) {
  print(i)
}

#Indlejrede løkker
for (i in 1:5) {
  for (j in c('a', 'b', 'c', 'd', 'e')) {
    print(paste(i,j))
  }
}

#Kan lave nye ting. Brug med omtanke ved store datasæt.
output_vector <- c()
for (i in 1:5) {
  for (j in c('a', 'b', 'c', 'd', 'e')) {
    temp_output <- paste(i, j)
    output_vector <- c(output_vector, temp_output)
  }
}
output_vector

#Computere er ineffektive til ovenstående. Det er bedre at definere størrelsen, hvis man kender den
output_matrix <- matrix(nrow=5, ncol=5)
j_vector <- c('a', 'b', 'c', 'd', 'e')
for (i in 1:5) {
  for (j in 1:5) {
    temp_j_value <- j_vector[j]
    temp_output <- paste(i, temp_j_value)
    output_matrix[i, j] <- temp_output
  }
}
output_vector2 <- as.vector(output_matrix)
output_vector2

#While løkker bruges, så længe en betingelse er sand
# while(this condition is true){
#   do a thing
# }

z <- 1
while(z > 0.1){
  z <- runif(1)
  cat(z, "\n")
}

#Write a script that loops through the gapminder data by continent and prints out
# whether the mean life expectancy is smaller or larger than 50 years.
#My solution
continent <- gapminder %>% 
  group_by(continent) %>%
  summarise(mean_life = mean(lifeExp))
  
continent
for (i in continent$mean_life) {
  if(i < 50) {
    print("Life expectancty is smaller than 50")
  }
  else {
    print("Life expectancy is larger than 50")
  }
}

#Carpentry's solution
gapminder <- read.csv("data/gapminder_data.csv")
unique(gapminder$continent)
for (iContinent in unique(gapminder$continent)) {
  tmp <- gapminder[gapminder$continent == iContinent, ]   
  cat(iContinent, mean(tmp$lifeExp, na.rm = TRUE), "\n")  
  rm(tmp)
}

thresholdValue <- 50

for (iContinent in unique(gapminder$continent)) {
  tmp <- mean(gapminder[gapminder$continent == iContinent, "lifeExp"])
  
  if(tmp < thresholdValue){
    cat("Average Life Expectancy in", iContinent, "is less than", thresholdValue, "\n")
  }
  else{
    cat("Average Life Expectancy in", iContinent, "is greater than", thresholdValue, "\n")
  } # end if else condition
  rm(tmp)
} # end for loop

#Modify the script from Challenge 3 to loop over each country.
# This time print out whether the life expectancy is smaller than 50, between 50 and 70, or greater than 70.
#My solution
country <- gapminder %>% 
  group_by(country) %>%
  summarise(mean_life = mean(lifeExp))
country

for (i in country$mean_life) {
  if(i < 50) {
    print("Life expectancty is smaller than 50")
  }
  else if (i > 50 & i < 70) {
    print("Life expectancy is larger than 50 but smaller than 70")
  }
  else {
    print("Life expectancy is lager than 70")
  }
}

#Carpentry's solution:
lowerThreshold <- 50
upperThreshold <- 70

for (iCountry in unique(gapminder$country)) {
  tmp <- mean(gapminder[gapminder$country == iCountry, "lifeExp"])
  
  if(tmp < lowerThreshold){
    cat("Average Life Expectancy in", iCountry, "is less than", lowerThreshold, "\n")
  }
  else if(tmp > lowerThreshold && tmp < upperThreshold){
    cat("Average Life Expectancy in", iCountry, "is between", lowerThreshold, "and", upperThreshold, "\n")
  }
  else{
    cat("Average Life Expectancy in", iCountry, "is greater than", upperThreshold, "\n")
  }
  rm(tmp)
}
