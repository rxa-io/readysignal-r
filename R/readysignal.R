#---------#
# GLOBALS #
#---------#

api_base <- "https://app.readysignal.com/api"
callback_url <- ""
auth_ <- NULL


#--------------------#
# EXPORTED FUNCTIONS #
#--------------------#

#' Init API Session
#'
#' initialize the API session with the access token
#'
#' @param access_token User access token
#' @export
init <- function(access_token) {
  assign("auth_", paste0("Bearer ", access_token), .GlobalEnv)
  url <- sprintf("%s/signals", api_base)
  resp <- httr::GET(url, httr::add_headers(Authorization = auth_))
  if (resp$status_code == 401) {
    stop("Failed to authenticate, please confirm your access token is correct.")
  }
}


#' List Signals
#'
#' lists all the signals associated with the User access token
#'
#' @return A data.frame containing the list of signals
#' @export
list_signals <- function() {
  check_auth()

  url <- sprintf("%s/signals", api_base)
  resp <- httr::GET(url, httr::add_headers(Authorization = auth_))

  json <- jsonlite::fromJSON(
    httr::content(resp, "text", encoding = "UTF8")
  )
  data <- json$data

  return(data)
}


#' List Signal Details
#'
#' shows the details for a specific signal
#'
#' @param signal_id Signal ID
#' @return A data.frame containing the details for a given signal
#' @export
get_signal_details <- function(signal_id) {
  check_auth()

  url <- sprintf("%s/signals/%s", api_base, signal_id)
  resp <- httr::GET(url, httr::add_headers(Authorization = auth_))

  json <- jsonlite::fromJSON(
    httr::content(resp, "text", encoding = "UTF8")
  )

  return(json$data)
}


#' Get Signal
#'
#' returns a signal's data in data.frame format
#'
#' @param signal_id Signal ID
#' @param infer_types Whether to infer column data types (defaults to TRUE)
#' @return A data.frame containing the data for a signal
#' @export
get_signal <- function(signal_id, infer_types = TRUE) {
  check_auth()

  url <- sprintf("%s/signals/%s/output?page=1", api_base, signal_id)
  sesh <- rvest::session(url, httr::add_headers(Authorization = auth_))

  json <- jsonlite::fromJSON(
    httr::content(sesh$response, "text", encoding = "UTF8")
  )
  data <- json$data

  ## TODO when get_signal_details contains # of rows,
  ## handle the progress bar better. that way, we could
  ## call the details first to get the number of rows, and
  ## and build the progress bar off of that, rather than
  ## making a potentially large request before making the bar

  # make the progress bar if gonna be needing to paginate
  if (json$last_page > 1) {
    pb <- progress::progress_bar$new(
      format = " [:bar] :percent / :elapsed",
      total = json$last_page - 1,
      clear = FALSE,
      width = 60
    )
  }

  while (json$current_page < json$last_page) {

    # don't show those HTTP 429 errors
    options(warn = -1)

    url <- sprintf(
      "https://app.readysignal.com/api/signals/%s/output?page=%d",
      signal_id,
      json$current_page + 1
    )
    sesh <- rvest::jump_to(sesh, url)

    while (sesh$response$status != 200) {
      Sys.sleep(10)
      sesh <- rvest::jump_to(sesh, url)
    }

    json <- jsonlite::fromJSON(
      httr::content(sesh$response, "text", encoding = "UTF8")
    )
    data <- rbind(data, json$data)

    pb$tick()
  }

  options(warn = 1)

  names(data) <- gsub("-", "_", names(data))

  if (infer_types) {
    for (i in seq_len(ncol(data))) {
      tryCatch(
        {
          data[[i]] <- as.Date(data[[i]])
          next
        },
        warning = function(e) {
        },
        error = function(e) {
        }
      )

      tryCatch(
        {
          data[[i]] <- type.convert(data[[i]])
        },
        warning = function(e) {
        },
        error = function(e) {
        }
      )
    }
  }

  return(data)
}


#' Save Signal to CSV
#'
#' saves signal data to CSV file
#'
#' @param signal_id Signal ID
#' @param file_name File name for the CSV
#' @export
signal_to_csv <- function(signal_id, file_name) {
  df <- get_signal(signal_id)
  write.csv(df, file_name)
}


#' Auto Discover
#'
#' create a signal with the Auto Discover feature
#'
#' @param geo_grain Geo-grain of upload, "State" or "Country"
#' @param filename Filename of .CSV or .XLS with "Date", "Value", "State"
#' (if geo_grain=State) columns, not to be used with `df`
#' @param df DataFrame with "Date", "Value", "State" (if geo_grain=State),
#' not to be used with `filename`
#' @return HTTP response
#' @export
auto_discover <- function(geo_grain, filename = NULL, df = NULL) {
  check_auth()

  if (!geo_grain %in% c("State", "Country")) {
    stop("`geo_grain` must be \"State\" or \"Country\"")
  }

  if (!is.null(filename)) {
    url <- sprintf("%s/auto-discovery/file", api_base)
    resp <- httr::POST(
      url,
      body = list(
        callback_url = callback_url,
        geo_grain = geo_grain,
        file = httr::upload_file(filename)
      ),
      httr::add_headers(Authorization = auth_)
    )
  } else if (!is.null(df)) {
    url <- sprintf("%s/auto-discovery/array", api_base)
    body <- list(
      callback_url = callback_url,
      geo_grain = geo_grain,
      data = df
    )
    body <- jsonlite::toJSON(body, auto_unbox = TRUE)
    body <- as.character(body)    
    resp <- httr::POST(
      url,
      body = body,
      httr::add_headers(
        Authorization = auth_,
        "Content-Type" = "application/json"
      )
    )
  } else {
    stop("Missing data source, please provide `filename` or `df`")
  }

  return(httr::content(resp))
}


#' Delete Signal
#'
#' deletes a signal
#'
#' @param signal_id Signal ID
#' @return HTTP response
#' @export
delete_signal <- function(signal_id) {
  check_auth()

  url <- sprintf("%s/signals/%s", api_base, signal_id)
  resp <- httr::DELETE(url, httr::add_headers(Authorization = auth_))
  return(httr::content(resp))
}


#--------------------#
# INTERNAL FUNCTIONS #
#--------------------#

check_auth <- function() {
  if (is.null(auth_)) {
    stop("Missing authentication, did you run `readysignal::init(...)`?")
  }
}
