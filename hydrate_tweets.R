# hydrate all of the tweets
# brachuno@purdue.edu

# option prevents scientific notation for tweet ids 
options(scipen = 999)

# imports
library('rtweet')

# set up credentials for tweets. These credentials come from
# your twitter developer acccount. 
create_token(app = "<APP NAME>",consumer_key = "<CONSUMER KEY>",
             consumer_secret = "<CONSUMER SECRET KEY",
             access_token = "<ACCESS TOKEN>",,
             access_secret = "<ACCESS SECRET>")


# read in statuss
# change the filename or path as needed. This should point at 
# the location of the tweet ID file. 

print("loading text")
ids <- read.csv(".dorian_ids.csv",header = F)
print("text loaded")

# convert to character for the lookup function
ids[,1] <- as.character(ids[,1])

# put tweets into the lookup_statuses function 90000 at a time then save them
tweets.rows <- seq(from=1,to=nrow(ids),by =90000)

# the rtweet package does not manage rate limits for you.
# here,  each batch of 90,000 tweets is saved in a seperate r
# file. That way if your process dies, you don't lose all of 
# the work.



print("startingloop")
for(i in 1:(length(tweets.rows)-1)){
  print(i)
  #start time
  start_time <-  Sys.time()
  
  # pull and save tweets
  pulled.tweets <-   lookup_statuses(ids[tweets.rows[i]:tweets.rows[1+i],],parse=T)
  filename <- paste0("./all_tweets_part",i)
  save(pulled.tweets,file=filename)
  rm(pulled.tweets)
  
  #if less than 15 minutes, wait the duration
  if( Sys.time()-start_time<15){
	print(paste0("Waiting for: ", 15-(Sys.time()-start_time)))
	Sys.sleep(15-(Sys.time()-start_time))
  }

  print("sleep over")
}
