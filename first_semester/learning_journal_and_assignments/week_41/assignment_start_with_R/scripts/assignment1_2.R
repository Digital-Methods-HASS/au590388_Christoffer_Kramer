#1) Use R to figure out how many elements in the vector below are greater than 2 .
#(You need to filter out the NAs first)

rooms <- c(1, 2, 1, 3, 1, NA, 3, 1, 3, 
           2, 1, NA, 1, 8, 3, 1, 4, NA, 1, 
           3, 1, 2, 1, 7, 1, NA)

#Create variable excluding NA from the vector
rooms_NA_removed <- rooms[!is.na(rooms)] 

#Extract numbers over 2
rooms_NA_removed[rooms_NA_removed > 2]

#show the length of previous output
length(rooms_NA_removed[rooms_NA_removed > 2])

#What is the result of running median() function on the above 'rooms' vector?
#(again, best remove the NAs)
median(rooms_NA_removed)
