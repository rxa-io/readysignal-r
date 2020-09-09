# Thanks to:
#   https://tinyheero.github.io/jekyll/update/2015/07/26/making-your-first-R-package.html


#' List Signals
#'
#' lists all the signals associated with the user's access token
#'
#' @param access_token User's access token
#' @return A data.frame containing the list of signals
#' @export
list_signals <- function(access_token) 
{ 
  url <- 'https://app.readysignal.com/api/signals?page=1'

  auth <- paste0("Bearer ", access_token)
  sesh <- rvest::html_session(url, httr::add_headers(Authorization=auth))

  json <- jsonlite::fromJSON(httr::content(sesh$response, "text", encoding="UTF8"))
  data <- json$data
  
  # make the progress bar if gonna
  # be needing to paginate
  if (json$meta$last_page > 1) {
    pb <- progress::progress_bar$new(
      format=" [:bar] :percent / :elapsed",
      total=json$meta$last_page-1,
      clear=FALSE,
      width=60
    )
  }

  while (json$meta$current_page < json$meta$last_page) {
    url <- sprintf('https://app.readysignal.com/api/signals?page=%d', json$meta$current_page + 1)
    sesh <- rvest::jump_to(sesh, url)
    
    json <- jsonlite::fromJSON(httr::content(sesh$response, "text", encoding="UTF8"))
    data <- rbind(data, json$data)
    
    pb$tick()
    Sys.sleep(1) # TODO, only sleep if HTTP 429
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
  url <- sprintf("https://app.readysignal.com/api/signals/%s", signal_id)

  auth <- paste0("Bearer ", access_token)
  resp <- httr::GET(url, httr::add_headers(Authorization=auth))

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
  url <- sprintf("https://app.readysignal.com/api/signals/%s/output?page=1", signal_id)

  auth <- paste0("Bearer ", access_token)
  sesh <- rvest::html_session(url, httr::add_headers(Authorization=auth))

  json <- jsonlite::fromJSON(httr::content(sesh$response, "text", encoding="UTF8"))
  data <- json$data
  
  # make the progress bar if gonna
  # be needing to paginate
  if (json$last_page > 1) {
    pb <- progress::progress_bar$new(
      format=" [:bar] :percent / :elapsed",
      total=json$last_page-1,
      clear=FALSE,
      width=60
    )
  }

  while (json$current_page < json$last_page) {

    # don't show those HTTP 429 errors
    options(warn=-1)

    url <- sprintf("https://app.readysignal.com/api/signals/%s/output?page=%d", signal_id, json$current_page + 1)
    sesh <- rvest::jump_to(sesh, url)

    while (sesh$response$status != 200) {
      Sys.sleep(10)
      sesh <- rvest::jump_to(sesh, url)
    }

    json <- jsonlite::fromJSON(httr::content(sesh$response, "text", encoding="UTF8"))
    data <- rbind(data, json$data)

    pb$tick()
  }

  options(warn=1)

  names(data) <- gsub("-", "_", names(data))
  
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
