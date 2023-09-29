## Sentimental analysis of an amazon product review 
library(syuzhet)

## Reading file

df <- read.csv("Amazon-reivew-export.csv",stringsAsFactors = FALSE)

## restored data in character format
review <- as.character(df $ Review.Content)

## obtain sentiment scores
get_nrc_sentiment("happy")
get_nrc_sentiment("abuse")

## store this data set into new variable
S1 <- get_nrc_sentiment(review)


## combine text and sentiment columns
review_sentiment1 <- cbind(df $Review.Content, S1)

## Bar plot for sentiments

custom_palette <- c("#40E0D0", "#FF3333", "#CCCCFF", "#FFD700", "#6A5ACD", 
                    "#808000", "#99FF99", "#008080", "#FA8072", "#EE82EE")
barplot(colSums(S1), col=custom_palette,xlab="sentiments", ylab='count', main='Amazon Feedback of Oral-B Electric Toothbrush')

dev.copy(png, "Sentiment_plot.png")
dev.off()



