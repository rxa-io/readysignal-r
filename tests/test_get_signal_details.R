source("../R/readysignal.R")

args <- commandArgs(trailingOnly=TRUE)

if(length(args) != 2) {
  stop("Missing correct arguments!\nUsage example: `Rscript test_get_signal_details.R <ACCESS_TOKEN> <SIGNAL_ID>`")
}

token <- args[1]
sigid <- args[2]

t1 <- Sys.time()
ret_json <- get_signal_details(token, sigid)

duration <- as.double(difftime(Sys.time(), t1, units='mins'))

cat("pulled signal details!", "\n")
cat("minutes:", duration, "\n")