# https://tinyheero.github.io/jekyll/update/2015/07/26/making-your-first-R-package.html

# move these to DESCRIPTION eventually!
library(httr)
library(jsonlite)

connect_to_readysignal <- function(access_token, signal_id=NA, output=FALSE)
{
  ## creates connection to correct API URL to list signals, show signal
  ## details, and return complete signal data
  ## :param access_token: user's unique access token
  ## :param signal_id: signal's unique ID number, to show signal details
  ## or output full signal
  ## :param output: show signal data or not
  ## :return:
  
	# list signals
  if(is.na(signal_id)) 
	{
    url <- 'http://app.readysignal.com/api/signals'
  }

	# show signal details
	else if(!output)
  {
    url <- sprintf("http://app.readysignal.com/api/signals/%s", signal_id)
  }
	
  # show signal
  else
  {
    url <- sprintf("http://app.readysignal.com/api/signals/%s/output", signal_id)
  }
  
  auth <- paste0("Bearer ", access_token)
  resp <- httr::GET(url, add_headers(Authorization=auth))
  
  return(resp)
}

list_signals <- function(access_token) 
{
  resp <- connect_to_readysignal(access_token)
  json <- jsonlite::fromJSON(httr::content(resp, "text"))
  return(json$data)
}

get_signal_details <- function(access_token, signal_id) 
{
  resp <- connect_to_readysignal(access_token, signal_id)
  json <- jsonlite::fromJSON(httr::content(resp, "text"))
  return(json$data)
}

get_signal <- function(access_token, signal_id) 
{
  resp <- connect_to_readysignal(access_token, signal_id, output=TRUE)
  json <- jsonlite::fromJSON(httr::content(resp, "text"))
  return(json$data)
}

signal_to_csv <- function(access_token, signal_id, file_name) 
{
  resp <- connect_to_readysignal(access_token, signal_id, output=TRUE)
  json <- jsonlite::fromJSON(httr::content(resp, "text"))
  df <- json$data
  
  write.csv(df, file_name)
}