# Thanks to:
#   https://tinyheero.github.io/jekyll/update/2015/07/26/making-your-first-R-package.html

# TODO rm these
# library(httr)
# library(jsonlite)
# library(rvest)
# token <- Sys.getenv("RSIG_TOKEN")
# sid <- 84


# this is a helper function,
# and is not accessible to the end user
make_api_request <- function(access_token, signal_id=NA, output=FALSE, page=1)
{
  # list signals
  if(is.na(signal_id)) 
  {
    url <- sprintf('https://app.readysignal.com/api/signals?page=%d', page)
  }
  
  # show signal details
  else if(!output)
  {
    url <- sprintf("https://app.readysignal.com/api/signals/%s", signal_id)
  }
  
  # show signal
  else
  {
    url <- sprintf("https://app.readysignal.com/api/signals/%s/output?page=%d", signal_id, page)
  }
  
  # set up auth and make request
  auth <- paste0("Bearer ", access_token)
  resp <- httr::GET(url, httr::add_headers(Authorization=auth))
  
  return(resp)
}


#' List Signals
#'
#' lists all the signals associated with the user's access token
#'
#' @param access_token User's access token
#' @return A data.frame containing the list of signals
#' @export
list_signals <- function(access_token) 
{ 
  resp <- make_api_request(access_token)
  json <- jsonlite::fromJSON(httr::content(resp, "text", encoding="UTF8"))
  
  data <- json$data
  
  while (json$meta$current_page < json$meta$last_page) {
    resp <- make_api_request(access_token, page=(json$meta$current_page + 1))
    json <- jsonlite::fromJSON(httr::content(resp, "text", encoding="UTF8"))
    data <- rbind(data, json$data)
  }
  
  return(data)
}


#' List Signal Details
#'
#' shows the details for a specific signal
#'
#' @param access_token User's access token
#' @param signal_id Signal ID
#' @return A data.frame containing the details for a given signal
#' @export
get_signal_details <- function(access_token, signal_id) 
{
  resp <- make_api_request(access_token, signal_id)
  json <- jsonlite::fromJSON(httr::content(resp, "text", encoding="UTF8"))
  return(json$data)
}


#' Get Signal
#'
#' returns a signal's data in data.frame format
#'
#' @param access_token User's access token
#' @param signal_id Signal ID
#' @return A data.frame containing the data for a signal
#' @export
get_signal <- function(access_token, signal_id) 
{
  print(sprintf("requesting page: %d", 1))

  resp <- make_api_request(access_token, signal_id, output=TRUE)
  json <- jsonlite::fromJSON(httr::content(resp, "text", encoding="UTF8"))
  
  print(sprintf("received page: %d", 1))
  cat("\n")

  data <- c(1,2,3)
  # data <- json$data
  
  while (json$current_page < json$last_page) {
    
    print(sprintf("requesting page: %d", json$current_page+1))

    resp <- make_api_request(access_token, signal_id, output=TRUE, page=(json$current_page + 1))
    json <- jsonlite::fromJSON(httr::content(resp, "text", encoding="UTF8"))
  
    print(sprintf("received page: %d", json$current_page))
    cat("\n")
    
    # data <- rbind(data, json$data)
    data <- rbind(data, c(1,2,3))
  }
  
  return(data)
}


#' Save Signal to CSV
#'
#' saves signal data to CSV file
#'
#' @param access_token User's access token
#' @param signal_id Signal ID
#' @param file_name File name for the CSV
#' @export
signal_to_csv <- function(access_token, signal_id, file_name) 
{
  df <- get_signal(access_token, signal_id)
  
  write.csv(df, file_name)
}
