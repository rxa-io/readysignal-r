source("../R/readysignal.R")

args <- commandArgs(trailingOnly=TRUE)

if(length(args) != 2) {
  stop("Missing correct arguments!\nUsage example: `Rscript test_get_signal.R <ACCESS_TOKEN> <SIGNAL_ID>`")
}

token <- args[1]
sigid <- args[2]

#
# TEST LIST SIGNALS
#
t1 <- Sys.time()
df <- df <- list_signals(token)
duration <- as.double(difftime(Sys.time(), t1, units='mins'))

cat("list_signals", "\n")
cat("  dim(df):", dim(df), "\n")
cat("  minutes:", duration, "\n\n")

#
# TEST GET SIGNAL
#
t1 <- Sys.time()
df <- df <- get_signal(token, sigid)
duration <- as.double(difftime(Sys.time(), t1, units='mins'))

cat("get_signal", "\n")
cat("  dim(df):", dim(df), "\n")
cat("  minutes:", duration, "\n\n")

#
# TEST GET SIGNAL DETAILS
#
t1 <- Sys.time()
df <- df <- get_signal_details(token, sigid)
duration <- as.double(difftime(Sys.time(), t1, units='mins'))

cat("get_signal_details", "\n")
cat("  minutes:", duration, "\n\n")

