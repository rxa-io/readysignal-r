# trying to see if using HTTP sessions
# fixed the issue...it didn't.
# but it gave a more detailed error
# message i think:
#   "In request_GET(x, url, ...) : Too Many Requests (RFC 6585) (HTTP 429)."

library(httr)
library(jsonlite)
library(rvest)
library(progress)

token <- Sys.getenv("RSIG_TOKEN")
sid <- 84

get_signal_dev <- function(access_token, signal_id) 
{
  url <- sprintf("https://app.readysignal.com/api/signals/%s/output?page=1", signal_id)
 
  auth <- paste0("Bearer ", access_token)
  sesh <- html_session(url, add_headers(Authorization=auth))
  
  json <- jsonlite::fromJSON(httr::content(sesh$response, "text", encoding="UTF8"))
  data <- json$data
  
  # make the progress bar if gonna
  # be needing to paginate
  if (json$last_page > 1) {
    pb <-progress_bar$new(
      format=" [:bar] :percent / :elapsed",
      total=json$last_page-1,
      clear=FALSE,
      width=60
    )
  }
  
  while (json$current_page < json$last_page) {
    url <- sprintf("https://app.readysignal.com/api/signals/%s/output?page=%d", signal_id, json$current_page + 1)
    sesh <- jump_to(sesh, url)
    
    json <- jsonlite::fromJSON(httr::content(sesh$response, "text", encoding="UTF8"))
    data <- rbind(data, json$data)
    
    pb$tick()
    Sys.sleep(1) # TODO, only sleep if HTTP 429
  }
  
  return(data)
}