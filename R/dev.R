# trying to see if using HTTP sessions
# fixed the issue...it didn't.
# but it gave a more detailed error
# message i think:
#   "In request_GET(x, url, ...) : Too Many Requests (RFC 6585) (HTTP 429)."

library(httr)
library(jsonlite)
library(rvest)

get_signal_dev <- function(access_token, signal_id) 
{
  auth <- paste0("Bearer ", access_token)

  print(sprintf("requesting page: %d", 1))
  
  url <- sprintf("https://app.readysignal.com/api/signals/%s/output?page=1", signal_id)
  sesh <- html_session(url, add_headers(Authorization=auth))
  
  json <- jsonlite::fromJSON(httr::content(sesh$response, "text", encoding="UTF8"))
  
  print(sprintf("received page: %d", 1))
  cat("\n")

  # data <- json$data
  data <- c(1,2,3)
    
  while (json$current_page < json$last_page) {
    print(sprintf("requesting page: %d", json$current_page+1))
    
    url <- sprintf("https://app.readysignal.com/api/signals/%s/output?page=%d", signal_id, json$current_page + 1)
    sesh <- jump_to(sesh, url)
    json <- jsonlite::fromJSON(httr::content(sesh$response, "text", encoding="UTF8"))
    
    print(sprintf("received page: %d", json$current_page))
    cat("\n")
    
    # data <- rbind(data, json$data)
    data <- rbind(data, c(1,2,3))
  }
  
  return(data)
}