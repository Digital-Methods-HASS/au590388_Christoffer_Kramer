library(tidyverse)

# Week 5
download.file("https://ndownloader.figshare.com/files/11492171",
              "data/SAFI_clean.csv", mode = "wb") #Download fil

interviews <- read_csv("data/SAFI_clean.csv", na = "NULL") #gem filen i et objekt

class(interviews)#Hvilken datatype er dette? (Hvs tbl så er det en tibble)
#En tipple er en lille del af datasættet

#Hvor mange rækker og kolonner er der
dim(interviews)

#HVor mange rækker er der?
nrow(interviews)

#Hvor mange kolonner er der
ncol(interviews)

#Viser de seks første rækker (Man kan tjekke noget af dataen ud)
head(interviews)

#Tjek slutningen af datasættet (Det er oftest smart at tjekke halen, da denne ofte har fejl)
tail(interviews)

#Se navnene på alle kolonnerne
names(interviews)

#
str(interviews)

#Trække værdier ud af en tibble før komma = rækker, (Her trækker jeg alle kolonner ud af række 1)
interviews[1,]

#Trække række 2 ud
interviews[2, ]

#Trække kolonne ud også, dette er højre side af kommaet
interviews[2,5]

#Kun trække kolonnen ud
interviews[,5]

#Flere rækker og kolonner
interviews[2:5,5:10]

#Subsette en vector gøres med c()
interviews[10:20,c(10,9,8,7,6,5,4,3,2,1)]

#Ekskludere data gøres med -(), det er en god måde at fjerne de data som ikke passer ind (f.eks. dårlig data)
interviews[-(10:20),]

#dollartegnet tager resultater for en kolonne. Denne metoder er væsentligt mere reproducerbar.
#Med denne metode er det ligegyldigt, hvor kolonnen er, der kan tilføjes kolonner uden problemer
interviews$years_liv

#Man kan bruge [] til at finde kolonner
interviews["village"]

interviews[,"village"]

#Find række 100
interviews[100,]

#Find midterpunktet, og træk den ud. 
interviews[round(nrow(interviews)/2),]

#Dplyr
#Vælg forskellige kolonner (Kan omrangere rækkefølgen)
select(interviews, years_liv, village)
filter(interviews, village == "Chirodzo")
#filter, man filtrerer efter en betingelse

#Pipes
#De er ligesom dem i shell. Den tager outputtet fra tidligere kommando og før det til datasættet for næste kommando
interviews %>% 
  select(years_liv, village) %>% 
  filter(village == "Chirodzo")
#Fordelen: Man slipper for at skrive mange ting flere gange,
#Man slipper for mellem variabler
#Select ændrer ikke dataen det gør filter og pipes heller ikke, man skal lave et nyt objekt for dette

intervieGod <- interviews %>% 
  select(years_liv, village) %>% 
  filter(village == "God")
intervieGod

#Mutate
interviews %>% 
  mutate(people_per_room = no_membrs / rooms) %>% 
  select(people_per_room)
#Her laves en ny kolonne people_per_room som indeholder no_membrs divideret med rooms
#Man har ikke ændret det oprindelige datasæt.

#Filter
interviews %>% 
  filter(!is.na(memb_assoc)) %>% 
  mutate(people_per_room = no_membrs / rooms) %>% 
  select(people_per_room)

#group_by and summarize()
#Group by viser dem som tre forskellige kolonner.
#Summarise kan bruges til at summere data. Man bruger filtre først. 
interviews %>% 
  group_by(village) %>% 
  summarise(mean_no_membrs = mean(no_membrs),
            min_no_membrs = min(no_membrs),
            max_membrs = max(no_membrs)) %>% 
  arrange(desc(mean_no_membrs))
#Arrange tager frå det mindsste til det største desc() gør det fra den største til den mindste
#Brug summarise og group_by i hjemmearbejdet.


#Tælle gøres med count()
interviews %>% 
  group_by(village) %>% 
  count(no_meals)

#Summarize gennemgår først en gruppe, herefter udfører, den det vi vil vide. Til sidst viser den resultatet.

#Animerede og interaktive kort. Man skal omdanne datasættet. Dette datasæt indeholdte.
#Adele startede med at udvide datasættet. Dette gjorde hun med pivot_wider eller pivot_longer()
#Man ved hvornår an skal bruge den. 
#Det er hvad der sker når man bruger OpenRefine.

interviews_plotting <- interviews %>%
  ## pivot wider by items_owned
  separate_rows(items_owned, sep = ";") %>%
  ## if there were no items listed, changing NA to no_listed_items
  replace_na(list(items_owned = "no_listed_items")) %>%
  mutate(items_owned_logical = TRUE) %>%
  pivot_wider(names_from = items_owned, 
              values_from = items_owned_logical, 
              values_fill = list(items_owned_logical = FALSE)) %>%
  ## pivot wider by months_lack_food
  separate_rows(months_lack_food, sep = ";") %>%
  mutate(months_lack_food_logical = TRUE) %>%
  pivot_wider(names_from = months_lack_food, 
              values_from = months_lack_food_logical, 
              values_fill = list(months_lack_food_logical = FALSE)) %>%
  ## add some summary columns
  mutate(number_months_lack_food = rowSums(select(., Jan:May))) %>%
  mutate(number_items = rowSums(select(., bicycle:car)))

write_csv(interviews_plotting, "output_data/interviews_plotting.csv")

#GGPlot plotting
interviews_plotting %>% 
  ggplot()

#Når den ikke får et paramter, gør den kun lærredet klar.
#Vi skal fortælle den hvad vi vil gøre.
interviews_plotting %>% 
  ggplot(aes(x = no_membrs, y = number_items)) +
  geom_jitter(aes(color = village))

#I GGplot, skal have paramter ggplot(aes(x= , Y=)). aes er en måde at vise, at det er æstetiske parametre.


interviews_plotting %>% 
  ggplot(aes(x = respondent_wall_type, y = rooms)) +
  geom_bar(stat = "identity")
#GGPLOT CHEATSHEET på google. 
