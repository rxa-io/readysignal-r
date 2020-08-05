# Thanks to:
#   https://tinyheero.github.io/jekyll/update/2015/07/26/making-your-first-R-package.html

# this is a helper function,
# and is not accessible to the end user
connect_to_readysignal <- function(access_token, signal_id=NA, output=FALSE)
{
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

  # set up auth and make request
  auth <- paste0("Bearer ", access_token)
  resp <- httr::GET(url, add_headers(Authorization=auth))
  
  return(resp)
}


#' List Signals
#'
#' TODO Function Description
#'
#' @param access_token User's access token
#' @return A data.frame containing the list of signals
#' @export
list_signals <- function(access_token) 
{
  resp <- connect_to_readysignal(access_token)
  json <- jsonlite::fromJSON(httr::content(resp, "text"))
  return(json$data)
}


#' List Signal Details
#'
#' TODO Function Description
#'
#' @param access_token User's access token
#' @param signal_id Signal ID
#' @return A data.frame containing the details for a given signal
#' @export
get_signal_details <- function(access_token, signal_id) 
{
  resp <- connect_to_readysignal(access_token, signal_id)
  json <- jsonlite::fromJSON(httr::content(resp, "text"))
  return(json$data)
}


#' Get Signal
#'
#' TODO Function Description
#'
#' @param access_token User's access token
#' @param signal_id Signal ID
#' @return A data.frame containing the data for a signal
#' @export
get_signal <- function(access_token, signal_id) 
{
  resp <- connect_to_readysignal(access_token, signal_id, output=TRUE)
  json <- jsonlite::fromJSON(httr::content(resp, "text"))
  return(json$data)
}


#' Save Signal to CSV
#'
#' TODO Function Description
#'
#' @param access_token User's access token
#' @param signal_id Signal ID
#' @param file_name File name for the CSV
#' @return NA
#' @export
signal_to_csv <- function(access_token, signal_id, file_name) 
{
  resp <- connect_to_readysignal(access_token, signal_id, output=TRUE)
  json <- jsonlite::fromJSON(httr::content(resp, "text"))
  df <- json$data
  
  write.csv(df, file_name)
}