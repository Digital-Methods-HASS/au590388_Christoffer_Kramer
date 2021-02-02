library(data.table)
more_pages <- map(webpages, ~fread(.x))

csv_pages <- map(webpages, ~read.table(.x))



Read data in

all_pages <- map(webpages[1:5], ~read_table(.x))
all_pages %>% set_names(2013:2017)

more_pages <- map(webpages[6:8], ~read_table(.x))
more_pages %>% set_names(2018:2020)

#' filter to keep only columns that have data in them, get rid of some HTML
x2 <- map(all_pages, ~.x %>%
filter(grepl("<tr><td><center>", .x)))

x2m <- map(more_pages, ~.x %>%
            filter(grepl("<tr><td>", .x)))
x2m[[1]]
library(glue)
x13 <- separate(x2[[1]], `<!-- saved from url=(0037)http://www.killedbypolice.net/kbp2013 -->`,
               into = glue('V{1:10}'),
                     sep = "<td>",
                     remove = FALSE)
x13t <- separate(x2[[1]], `<!-- saved from url=(0037)http://www.killedbypolice.net/kbp2013 -->`,
                into = glue('V{1:10}'),
                sep = "<td>",
                remove = TRUE)
#------------------------------------------------------------------------------

#' convert list of data frames to one big data frame
x4 <- bind_rows(x3)

#------------------------------------------------------------------------------

# test of list knowledge
n = c(2, 3, 5)
s = c("aa", "bb", "cc", "dd", "ee")
b = c(TRUE, FALSE, TRUE, FALSE, FALSE)
x = list(n, s, b, 3)   # x contains copies of n, s, b
x
names(x)



# TEST MAP AND SEPARATE
x3 <- map(x2, ~.x  %>%
						# split variables into cols
						separate(select(.x, starts_with("<!-- saved from url")),
										 into = glue('V{1:10}'),
										 sep = "<td>",
										 remove = FALSE))


f1 <- function(dat, col1) separate(dat, {{col1}}, into = glue('V{1:10}', sep = "<td>", remove = FALSE);
f1(head(iris), Species)
tail(x2)
