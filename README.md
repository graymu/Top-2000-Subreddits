# Top 2,000 Subreddits
Reddit.com is a massive social media site with thousands of unique communities that focus on topics of all kinds. I was interested in learning more about the top communities, called "subreddits", on the entire webiste. I decided to collect data provided by reddit.com itself about the largest subreddits on the platform and use that data to learn about the types of communities that are most popular. 

### This project contains a few files:

For the web-scraping in this project, I collect information across 8 pages of reddit's [community rankings](https://www.reddit.com/best/communities/1/). Each page contains 250 subreddits in descending order of size, so my final dataset contains 2,000 subreddits (8x250) total. My process is documented in two R scripts:

[reddit_scraping_script.R](../main/reddit_scraping_script.R) contains the code I use to extract and clean data from the webpage.

[reddit_scraping_urls.R](../main/reddit_scraping_urls.R) runs the scraping function on all 8 URLs and combines them into my final data.

My exploratory data analysis extracts a bunch of interesting insights from this dataset and creates charts for a few aspects of the category information. See my full analysis [here.](../main/Top-2000-Subreddits-Analysis.md)


