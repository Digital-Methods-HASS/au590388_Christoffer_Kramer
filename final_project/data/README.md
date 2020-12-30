# candidates_since_1960.csv
* *Author*: Christoffer Mondrup Kramer
* *Creation Date*: 12-11-2020 (day-month-year)
* *Description*: This data was produced manually by me. It contains a list of all presidential and vice-presidential candidates since 1960, including the year they ran, what position they ran for, and their party affiliation.
* *License*: Creative commons.

## Variables
* **year** (integer): What year did the candidate run.
* **party** (string): What party was the candidate affiliated with.
  * **values**
  * *D*: The candidate was a democrat
  * *R*: The candidate was a republican
  * *I*: The candidate was an independent
* **last_name** (string): What was the candidate's last name.
* **first_name** (string): What was the candidate's first_name.
* **position** (string): What position did the candidate run for.
  * **values**
  * *president*: The candidate ran for the presidency.
  * *vice_president*: The candidate ran for the vice-presidency.

# all_debates_raw.csv
* *Author*: The Commission on Presidential debates (https://www.debates.org/). 
* *Creation Date*: Last web-scraped in December 2020.
* *Description*: This data was produced automatically by web-scraping and contains transcripts from presidential and vice-presidential debates since 1960. 
* *source*: https://www.debates.org/voter-education/debate-transcripts/
* *License*: I contacted The Commission on Presidential Debates in order to gain permission to use the transcripts. They informed me that the transcripts are in the public domain.

## Variables
* **line** (integer): The line number in the original transcript
* **text** (string): What text did the line contain
* **date** (string): At what date was the debate held. This information is gained by using a regex to match the date in the link to the transcript. Some of the dates, therefore, needs cleaning, which is done in the script *2_data_cleaning.R*. 


