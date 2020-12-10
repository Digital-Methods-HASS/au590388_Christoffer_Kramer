# Purpose
This project is part of my final exam for the digital methods class at Aarhus University.
This program i part of a data-driven assignment, where I text-mine presidential and vice-presidential debates since 1960. 

*Author*: Christoffer Mondrup Kramer

# Folders and contents
* **data**: Contains all raw data used in the scripts.
* **Final_exam_paper**: Here is my document to be handed in for the final exam. The markdown file  *final_project* is knitted to word and saved as *final-exam* where I have done some formatting, changed some paragraphs, and added my previous portfolios.
* **scripts**: All scripts used in the Rmarkdown resides here.
  * **extra_scripts**: These are scripts, that I, sadly, didn't have room for in my final exam. 
* **plots**: All plots from the scrips (or the Rmarkdown) are saved here.
  * **extra**: All plots from the scripts in the sub-folder *extra_scripts* are saved here.

# Technical specifications:
* **Programming language**: R
* **Version**: 4.0.2
* **Software**: This project is produced in RStudio

*Packages*

This project uses the following packages:
- Fellows, I. (2018). "wordcloud: Word Clouds". Located at CRAN here: https://cran.r-project.org/web/packages/wordcloud/index.html 
- Grolemund, G. & Wickham, H. (2011). ”Dates and Times Made Easy with lubridate”. Journal of Statistical Software, 40(3), 1-25. URL http://www.jstatsoft.org/v40/i03/
- Pennec, L. E. (2019). "ggwordcloud: A Word Cloud Geom for 'ggplot2'". Located at CRAN here: https://cloud.r-project.org/web/packages/ggwordcloud/index.html 
- Silge, J. & Robinson, D. (2017). “Text Mining with R: A Tidy Approach”. O’reilly Media, Inc. URL: https://www.tidytextmining.com/ 
- Wickham, H (2016). “ggplot2: Elegant Graphics for Data Analysis.” Springer-Verlag New York. ISBN 978-3-319-24277-4, https://ggplot2.tidyverse.org 
- Wickham, H. (2020). “rvest: Easily Harvest (Scrape) Web Pages”. Located at CRAN here: https://cran.r-project.org/web/packages/rvest/index.html 
- Wickham, H. (2007). “Reshaping Data with the reshape Package.” Journal of Statistical Software, 21(12), 1–20. http://www.jstatsoft.org/v21/i12/.
- Wickham H et al. (2019). “Welcome to the tidyverse.” Journal of Open Source Software, 4(43), 1686. doi: 10.21105/joss.01686
- Zeileis, A. & Grothendieck, G. (2005). “zoo: S3 Infrastructure for Regular and Irregular Time Series.” Journal of Statistical Software, 14(6), 1–27. doi: 10.18637/jss.v014.i06

# How to run 
* Run the scripts in the following order:
  1. *1_webscrape.R*
  2. *2_data_cleaning.R*
  3. *3_text-mining.R*
* All plots can now be examined in the folder *plots*

## Running the extra scripts
* Run the scripts in the following order:
  1. *1_webscrape.R*
  2. *2_data_cleaning.R*
  3. *3_text-mining.R*
* Run the scripts from *extra_scripts* in the following order:
  1. *1_extra_tf-idf_stop_word_filtering.R*
  2. *2_extra_sentiment_analysis.R*
* All plots can now be examined in the folder *plots* and plots from the scripts in *extra_scripts* can be examined in the sub-folder *extras*.

# Trouble shooting and reproducibility 
I can't guarantee that my data-source for the web-scraping will stay intact forever. Therefore, the result from the web-scraping are saved as a .CSV file. 
If you run into problems with the the script *1_webscrape.R* it might be the result of changes to the website. If this happens, you can skip it and run *2_data_cleaning.R* followed by *3_text-mining.R*.

# Plots
I the script **3_text-mining.R** will produce the following plots:
* **fig_1.pdf**: Word clouds which displays the top 20 most used word each year and for each party.
* **fig_2.pdf**: Word clouds which displays the top 20 words with the highest tf-idf each year for both parties.
* **fig_3.pdf**: Pie charts which displays how republicans sentiments have changed each year (BING lexicon).
* **fig_4.pdf**: Pie charts which displays how democrats sentiments have changed each year (BING lexicon).

## Extra plots
These plots aren't included in my final exam!
The script **1_extra_tf-idf_stop_word_filtering.R** will produce the following plots:
* **extra_commonality_cloud.pdf**: A word cloud that displays which words the parties shares the most.
* **extra_comparison_cloud.pdf**: A comparison cloud that displays what words each party use across all years.
* **extra_tf_idf_by_party**: A word cloud that displays the top 20 words with the highest tf-idf for each party across all years.

The script **2_extra_sentiment_analysis.R** will produce the following plots:
* **extra_democrats_total_sentiment_BING.pdf**: A pie chart that shows the democrats total sentiment across all years (BING lexicon).
* **extra_republicans_total_sentiment_BING.pdf**: A pie chart that shows the republicans total sentiment across all years (BING lexicon).
* **extra_total_sentiment_distribution_both_parties.pdf**: Two bar charts that show both parties total sentiment distribution across all years (Afinn lexicon).
* **extra_sentiment_distribution_by_year_and_party.pdf**: Bar charts that shows each party's sentiment distribution, by year (Afinn lexicon).
* **extra_distortion_each_year.pdf**: A bar chart that shows how skewed the sentiment analysis is each year based on negation words (afinn lexicon).
* **extra_sentiment_distortion_top_30_words.pdf**: A bar chart that shows how which top 30 words skew the results the most (afinn lexicon).
* **extra_sentiment_comparison_cloud_democrats.pdf**: A comparison cloud that compares the negative and positive words for the democrats (BING lexicon).
* **extra_sentiment_comparison_cloud_republicans.pdf**: A comparison cloud that compares the negative and positive words for the republicans (BING lexicon).
* **extra_word_cloud_by_year_party_sentiment_and_count**: Word clouds that are facetted by year and party, which displays how each party have changed their sentiment and word count for each year (afinn lexicon).

# Metadata
All metadata for my data sets are provided in the *README* file in the folder *data*.

# License
This whole repository is licensed under *creative commons*. Feel free to use it in any way you whish. 
The transcripts are in the *public domain*. 