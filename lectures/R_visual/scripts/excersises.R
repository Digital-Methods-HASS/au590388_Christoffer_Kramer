filter(flights, month == 1, day == 1)
jan1 <- filter(flights, month == 1, day == 1)
(dec25 <- filter(flights, month == 1, day == 1))
filter(flights, arr_delay >= 120)
filter(flights, dest == "HOU" | dest == "IAH")
filter(flights, dest %in% c("IAH", "HOU"))
filter(flights, carrier == "UA"  | carrier == "DL")
filter(flights, month %in% c(7, 8, 9))
filter(flights, between(month, 7,9))
filter(flights, arr_delay > 120 & dep_delay <= 0)
filter(flights, dep_delay >= 60 & arr_delay <= dep_delay - 30)
filter(flights, between(dep_time, 0000, 0600))
rlang::last_error()
filter(flights, is.na(dep_time))
arrange(flights, desc(is.na(flights)))
arrange(flights, desc(arr_delay))
arrange(flights, dep_time)        
view(arrange(flights, desc(distance, hour, minute)))
view(arrange(flights, desc(distance)))
view(arrange(flights, distance))
select(flights, dep_time:arr_delay, everything())
select(flights, dep_time, dep_time, dep_delay)
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, any_of(vars))
any_of(flights)
select(flights, matches("TIME"))
transmute(flights, 
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100)
transmute(flights, 
          sched_dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100)

transmute(flights,
          arr_time,
          time = arr_time - dep_time)

transmute(flights,
          arr_time,
          hour = (arr_time - dep_time) %/% 100,
          minute = (arr_time - dep_time) %% 100)
view(min_rank(select(flights, arr_delay)))
1:3 + 1:10

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))         

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay =mean(dep_delay, na.rm = TRUE))

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count > 20, dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

delays <- flights %>%
  group_by(dest) %>%
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    deæay = mean(arr_delay, na.rm = TRUE)
    ) %>%
  filter(count > 20, dest != "HNL")

flights %>% 
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay))

flights %>% 
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay, na.rm = TRUE))
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay))

ggplot(data = delay, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n())
ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

delays %>% 
  filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

batting <- as_tibble(Lahman::Batting)
batters <- batting %>%
  group_by(playerID) %>%
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )
batters %>% 
  filter (ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() +
  geom_smooth(se = FALSE)


batters %>%
  arrange(desc(ba))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay = mean(arr_delay[arr_delay > 10])
  )

not_cancelled %>% 
  group_by(dest) %>%
  summarise(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))

not_cancelled %>%
  group_by(arr_delay,dep_delay) %>%
  summarise(
    first = min(dep_time),
    last = max(dep_time))
  

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(
    first_dep = first(dep_time),
    last_dep = last(dep_time))

not_cancelled %>% 
  group_by(year, month, day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))

not_cancelled %>% 
  group_by(dest) %>%
  summarise(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

not_cancelled %>% count(dest)

not_cancelled %>% 
  count(tailnum, wt = distance)

not_cancelled %>% 
  group_by(year, month, day) %>%
  summarise(n_early = sum(dep_time < 500))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_prop = mean(arr_delay > 60))

daily <- group_by(flights, year, month, day)
(per_day <- summarise(daily, flights = n()))

(per_month <- summarise(per_day, flights = sum (flights)))

(per_year <- summarise(per_month, flights = sum(flights)))

daily %>% 
  ungroup() %>%
  summarise(flights = n())

flights %>%
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

popular_dest <- flights %>%
  group_by(dest) %>%
  filter(n() < 365)

popular_dest

popular_dest %>%
  filter(arr_delay > 10) %>%
  select(year:day, dest, arr_delay, prop_delay)
