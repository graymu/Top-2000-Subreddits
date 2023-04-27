# A script for scraping data from Reddit.com's ranked list of top communities on the site.

# Helper Function
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

# Main Scraping Function
scrape_reddits <- function(url) {
  
  # First, I get the html content of the url's webpage with this code.
  htmlcontent <- read_html(url)
  
  # Note: I retrieve all CSS Selectors in html_nodes using Firefox's handy developer tools.
  
  ########### Retrieve the Name Variable
  
  subreddit_name <- htmlcontent %>% 
    html_elements("a") %>% 
    html_text()
  
  # Trim the useless information on the beginning and end
  subreddit_name <- subreddit_name[-c(1:4)]
  subreddit_name <- subreddit_name[-c(251:513)]
  
  # Replace unwanted characters to extract just the name
  subreddit_name <- gsub('\n','', subreddit_name)
  subreddit_name <- gsub(' ','', subreddit_name)
  
  ########### Retrieve the Category Variable
  
  subreddit_category <- htmlcontent %>% 
    html_nodes('div:nth-child(3) > h6:nth-child(2)') %>% 
    html_text()
  
  # Replace unwanted characters to extract just the category
  subreddit_category <- gsub('\n','', subreddit_category)
  subreddit_category <- gsub('  ','', subreddit_category)
  
  ########### Retrieve the Members Variable
  
  subreddit_members <- htmlcontent %>% 
    html_nodes('div:nth-child(3) > h6:nth-child(3) > faceplate-number') %>%
    html_attr("number") %>% 
    as.numeric()
  
  ###########
  
  # Create the full tibble for this data
  subreddits_df <- tibble(subreddit_name, subreddit_category, subreddit_members)
}


