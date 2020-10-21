

mean_life_country <- as.data.frame(gapminder) %>% #Create a new object called "mean_life_country"
  group_by(country) %>% #group by country
  filter(str_detect(country, "^B")) %>% #remove all rows where the value of 
                                        #the first letter of the column "country" do not start with B
  summarise(mean_life = mean(lifeExp)) #create a new column called "mean_life" which is the average
                                        # life expectancy for each country

write.csv(mean_life_country, "mean_life_country.csv") #create a csv document called "mean_life_country.csv", which contains the previous object

mean_life_country <- read.csv("mean_life_country.csv") #let the object "mean_life_country" contain the csv file

for (i in mean_life_country$country) { #for every country in "mean_life_country"
  
  mean_life <- mean_life_country[mean_life_country$country == i, "mean_life"] #create an object called "mean_life, which is a subvector of "mean_life_country" 
  
  if(mean_life < 50) { #if "mean life i smaller than 50
    cat("The life expectancy of", i, "is smaller than 50", "(",mean_life,")\n") #print this out
  }
  else if (mean_life > 50 && mean_life < 70) { #if "mean life" is larger than 50 and smaller than 70
    cat("The life expectancy of", i, "is between 50 and 70", "(",mean_life,")\n") #print this out
    
  } else { #if "mean_life is larger than 70
    cat("The life expectancy of", i, "is larger than 70", "(",mean_life,")\n") #print this out
    
  }

}

