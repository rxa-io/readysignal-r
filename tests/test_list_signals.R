source("../R/readysignal.R")

args <- commandArgs(trailingOnly=TRUE)

if(length(args) != 1) {
  stop("Missing correct arguments!\nUsage example: `Rscript test_list_signals.R <ACCESS_TOKEN>`")
}

token <- args[1]

t1 <- Sys.time()
df <- list_signals(token)

duration <- as.double(difftime(Sys.time(), t1, units='mins'))

cat("dim(df):", dim(df), "\n")
cat("minutes:", duration, "\n")