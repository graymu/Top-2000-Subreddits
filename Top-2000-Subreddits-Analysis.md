Top Subreddits EDA
================
Gray Underhill
2023-04-21

## Introduction

This exploratory data analysis takes a look at data I scraped from
reddit.com about the largest 2,000 communities, called “subreddits”, on
the site. The analysis here breaks down the “Subreddit Category”
variable and looks at how categories are represented and distributed
across the top 2,000. At the end, I take what I learn in this analysis
and see what further questions it inspires.

## The Analysis

#### Loading the Data

``` r
library(tidyverse)
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.0     ✔ readr     2.1.4
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.0
    ## ✔ ggplot2   3.4.1     ✔ tibble    3.1.8
    ## ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
    ## ✔ purrr     1.0.1     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the ]8;;http://conflicted.r-lib.org/conflicted package]8;; to force all conflicts to become errors

``` r
library(scales)
```

    ## 
    ## Attaching package: 'scales'
    ## 
    ## The following object is masked from 'package:purrr':
    ## 
    ##     discard
    ## 
    ## The following object is masked from 'package:readr':
    ## 
    ##     col_factor

``` r
subreddit_data <- read.csv("./full_subreddit_list.csv")
```

**First, I take a look at how the data loaded in.**

``` r
head(subreddit_data)
```

    ##    subreddit_name     subreddit_category subreddit_members rank
    ## 1         r/funny            Funny/Humor          48643409    1
    ## 2     r/AskReddit Learning and Education          40689080    2
    ## 3           r/aww       Animals and Pets          33849677    3
    ## 4         r/Music                  Music          32176607    4
    ## 5 r/todayilearned Learning and Education          31320099    5
    ## 6        r/movies                 Movies          30782468    6

This appears to be correct. The column names and first rows are
identical to the output of the data scraping from earlier.

#### Summarizing the Data

**I create a new data frame to summarize the category information in the
full list.**

``` r
category_summary <- subreddit_data %>% 
  group_by(subreddit_category) %>% 
  summarise(category_count = n(), average_members = round(mean(subreddit_members),0)) %>% 
  arrange(subreddit_category)

head(category_summary)
```

    ## # A tibble: 6 × 3
    ##   subreddit_category category_count average_members
    ##   <chr>                       <int>           <dbl>
    ## 1 Activism                       11          353750
    ## 2 Addiction Support               1          207910
    ## 3 Animals and Pets              120          677879
    ## 4 Anime                          33          497323
    ## 5 Art                            91          721564
    ## 6 Beauty and Makeup              29          419940

This looks good. Now I can begin plotting.

#### Plotting the Data

**First, what are the most common subreddit categories across the top
2,000?**

``` r
common_categories <- top_n(category_summary, 20, category_count)
common_categories <- arrange(common_categories, -category_count)

# Create the plot using the common_categories data
ggplot(data = common_categories, aes(x=subreddit_category,y=category_count)) + 
  geom_col() +
  theme(axis.text.x = element_text(angle=90,hjust=0.95)) +
  labs(title="Most Common 20 Categories", x="Category", y="Count") +
  scale_x_discrete(limits=common_categories$subreddit_category)
```

![](Top-2000-Subreddits-Analysis_files/figure-gfm/most%20common%20categories-1.png)<!-- -->

**Next, what is the largest average community size for each of the
categories?**

``` r
largest_categories <- top_n(category_summary, 10, average_members)
largest_categories <- arrange(largest_categories, -average_members)

# Create the plot using the largest_categories data
ggplot(data = largest_categories, aes(x=subreddit_category,y=average_members)) + 
  geom_col() +
  theme(axis.text.x = element_text(angle=90,hjust=0.95)) +
  labs(title="Largest 10 Category Sizes", x="Category", y="Average Members") +
  scale_x_discrete(limits=largest_categories$subreddit_category) +
  scale_y_continuous(labels=unit_format(unit="M", scale=1e-6))
```

![](Top-2000-Subreddits-Analysis_files/figure-gfm/largest%20category%20member%20size-1.png)<!-- -->

**Third, what are the rarest categories in the top 2,000?**

``` r
category_summary <- arrange(category_summary, category_count)
rare_categories <- head(category_summary, 10)

# Create the plot using the rare_categories data
ggplot(data = rare_categories, aes(x=subreddit_category,y=category_count)) + 
  geom_col() +
  theme(axis.text.x = element_text(angle=90,hjust=0.95)) +
  labs(title="Rarest 10 Categories", x="Category", y="Count") +
  scale_x_discrete(limits=rare_categories$subreddit_category) +
  scale_y_continuous(breaks=seq(0,10,2))
```

![](Top-2000-Subreddits-Analysis_files/figure-gfm/rarest%20categories-1.png)<!-- -->

#### Extra Information

**Now for some last miscellaneous, fun information.**

*How many members are there across the entire top 2,000 subreddits?*

``` r
total_subscribers <- sum(subreddit_data$subreddit_members)

prettyNum(total_subscribers, big.mark=",",scientific=FALSE)
```

    ## [1] "1,616,845,903"

How many communities have more than 10 million subscribers? More than 1
million? More than 100 thousand?

``` r
tenmil <- subreddit_data %>% 
  filter(subreddit_members>=10000000) %>% 
  nrow()
onemil <- subreddit_data %>% 
  filter(subreddit_members>=1000000) %>% 
  nrow()
hundredk <- subreddit_data %>% 
  filter(subreddit_members>=100000) %>% 
  nrow()

milestones <- c("At Least 10 Million","At Least 1 Million","At least 100 Thousand")
milestone_count <- c(tenmil,onemil,hundredk) 

member_milestones <- data.frame(milestones, milestone_count) %>% 
  print()
```

    ##              milestones milestone_count
    ## 1   At Least 10 Million              28
    ## 2    At Least 1 Million             259
    ## 3 At least 100 Thousand            1726

Only 28 communities break the lofty member count of 10 million, but most
of the communities on my full list have at least 100 thousand members.
That’s a lot of very large communities.

## Further Questions

The data that I gathered from reddit.com, while provided directly from
the host website, is not entirely accurate. Thanks to other data
collection sites such as subredditstats.com, I have learned that there
are many communities that the data on reddit.com omits from its own
community rankings.

For example, in the Top 10 of my data alone, r/gaming (36M members),
r/worldnews (31M members), r/science (29M members), and r/pics (29M
members) are inexplicably missing.

Further exploration into subreddit data should include a more complete
list of the top communities on the website. Maybe I can look into a
larger subset than just 2,000 communities as well. Reddit has tens of
thousands of active communities that I could look into.

Questions for further exploration could include:

> Does the category information I explored here change when looking at a
> larger group of subreddits? How about 5,000? 10,000?

> Are top subreddits more general or more specific? How many top
> subreddits cover a narrow subject? How might that be defined?

> How many top subreddits are non-English-speaking?

> How many subreddits exist across the entire site? Or how many have at
> least 100 or 1,000 members?

> Is historic information available? How do the top 100 subreddits
> compare to, say, those of 5 years ago?
