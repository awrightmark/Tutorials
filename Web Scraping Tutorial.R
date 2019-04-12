library(rvest)
library(textreadr)

# Specify the url to be scraped
url <- "http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature"

# Read the HTML code from the website
webpage <- read_html(url)

# Use the CSS selectors to scrape the appropiate section(s)
rank_data_html <- html_nodes(webpage, ".text-primary")
title_data_html <- html_nodes(webpage, "div.lister-item-content > h3 > a")
runtime_data_html <- html_nodes(webpage, "span.runtime")
genre_data_html <- html_nodes(webpage, "span.genre")
rating_data_html <- html_nodes(webpage, "div.lister-item-content > div > div.inline-block.ratings-imdb-rating > strong")

# Store all data as appropriate data types
rank_data <- html_text(rank_data_html)
rank_data <- as.numeric(rank_data)
title_data <- html_text(title_data_html)
runtime_data <- html_text(runtime_data_html)
runtime_data <- gsub(" min", "", runtime_data)
runtime_data <- as.numeric(runtime_data)
genre_data <- html_text(genre_data_html)
genre_data <- gsub("\n", "", genre_data)
rating_data <- html_text(rating_data_html)
rating_data <- as.numeric(rating_data)

# Combine all data vectors into one dataframe
movies_df <- data.frame(Rank = rank_data, Title = title_data, RunTime = runtime_data, Genre = genre_data, Rating = rating_data)
head(movies_df)
