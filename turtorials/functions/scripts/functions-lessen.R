library(tidyverse)
install.packages("gapminder")
library(gapminder)


#Omdan fahrenheit til kelvin temperatur
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5/9)) + 273.15
  return(kelvin)
}

#kald funktionen
fahr_to_kelvin(32)

fahr_to_kelvin(212)

#Write a function called kelvin_to_celsius() that takes a temperature in Kelvin and returns that temperature in Celsius.
kelv_to_celc <- function(temp) {
  celcius <- temp -273.15
  return(celcius)
  
}

kelv_to_celc(300)

#Funktioners største fordel kommer af deres evne til at blive kombineret.
#Define the function to convert directly from Fahrenheit to Celsius, by reusing the two functions above
farh_to_celc <- function(temp) {
 temp_kelvin  <- fahr_to_kelvin(temp)
 result <- kelv_to_celc(temp_kelvin)
 return(result)
}

farh_to_celc(300)

#Defensive programming: Man skal gøre opmærksom på, hvilke fejl der sker. Man skal få funktionen til at stoppe ved fejl.
#Man kan bruge en if-statement
fahr_to_kelvin <- function(temp) {
  if (!is.numeric(temp)) {
    stop("temp must be a numeric vector.")
  }
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}

#Men det er bedre at bruge stopifnot() da man kan bruge flere parametre og man slipper for at skrive fejlen

fahr_to_kelvin <- function(temp) {
  stopifnot(is.numeric(temp))
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
fahr_to_kelvin(32)

#Laver fejl, hvis det ikke er korrekt datatype
fahr_to_kelvin(temp = as.factor(32))

#Use defensive programming to ensure that our fahr_to_celsius() 
#function throws an error immediately if the argument temp is specified inappropriately.
farh_to_celc <- function(temp) {
  stopifnot(is.numeric(temp))
  temp_kelvin  <- fahr_to_kelvin(temp)
  result <- kelv_to_celc(temp_kelvin)
  return(result)
}
farh_to_celc(32)
farh_to_celc("hej")

# Takes a dataset and multiplies the population column
# with the GDP per capita column.
calcGDP <- function(dat) {
  gdp <- dat$pop * dat$gdpPercap
  return(gdp)
}


calcGDP(head(gapminder))

# Takes a dataset and multiplies the population column
# with the GDP per capita column.
calcGDP <- function(dat, year=NULL, country=NULL) {
  if(!is.null(year)) {
    dat <- dat[dat$year %in% year, ]
  }
  if (!is.null(country)) {
    dat <- dat[dat$country %in% country,]
  }
  gdp <- dat$pop * dat$gdpPercap
  
  new <- cbind(dat, gdp=gdp)
  return(new)
}

head(calcGDP(gapminder, year=2007))
calcGDP(gapminder, country="Australia")
calcGDP(gapminder, year=2007, country="Australia")

#Test out your GDP function by calculating the GDP for New Zealand in 1987. 
#How does this differ from New Zealand’s GDP in 1952?
calcGDP(gapminder, year = 1987, country = "New Zealand")
calcGDP(gapminder, year = 1952, country = "New Zealand")
#Carpentry's solution:
calcGDP(gapminder, year = c(1952, 1987), country = "New Zealand")

#My solution (Did not work properly)
fence <- function(text, wrapper) {
 pasted_text <- paste(text, collapse = wrapper)
 return(pasted_text)
}
best_practice <- c("Write", "programs", "for", "people", "not", "computers")
fence(text=best_practice, wrapper="***")

#Carpentry's solution:
fence <- function(text, wrapper){
  text <- c(wrapper, text, wrapper)
  result <- paste(text, collapse = " ")
  return(result)
}
best_practice <- c("Write", "programs", "for", "people", "not", "computers")
fence(text=best_practice, wrapper="***")
