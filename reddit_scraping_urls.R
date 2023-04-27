# This script is the "control panel" that runs the scraping function from reddit_scraping_script.R on each of the URLs that I need.

library("tidyverse")
library("rvest")
library("stringr")
source("./reddit_scraping_script.R")

# Store each URL to scrape data from
url1 <- 'https://www.reddit.com/best/communities/1/'
url2 <- 'https://www.reddit.com/best/communities/2/'
url3 <- 'https://www.reddit.com/best/communities/3/'
url4 <- 'https://www.reddit.com/best/communities/4/'
url5 <- 'https://www.reddit.com/best/communities/5/'
url6 <- 'https://www.reddit.com/best/communities/6/'
url7 <- 'https://www.reddit.com/best/communities/7/'
url8 <- 'https://www.reddit.com/best/communities/8/'

# Perform the data scraping and create a data frame for each webpage of scraped data
subreddit_df1 <- scrape_reddits(url1)
subreddit_df2 <- scrape_reddits(url2)
subreddit_df3 <- scrape_reddits(url3)
subreddit_df4 <- scrape_reddits(url4)
subreddit_df5 <- scrape_reddits(url5)
subreddit_df6 <- scrape_reddits(url6)
subreddit_df7 <- scrape_reddits(url7)
subreddit_df8 <- scrape_reddits(url8)


# Combine each smaller data frame into one large one
full_subreddit_list <- rbind(subreddit_df1, subreddit_df2, subreddit_df3, subreddit_df4, 
                             subreddit_df5, subreddit_df6, subreddit_df7, subreddit_df8)

# Add a new column with the community size ranking, for ease of use later
ranked_list <- c(1:2000)
full_subreddit_list$rank <- ranked_list

# Save the completed data frame as a CSV file
write_csv(full_subreddit_list, "./full_subreddit_list.csv")