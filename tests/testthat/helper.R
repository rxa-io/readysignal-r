# REQUIRED: set the RS_TOKEN environment var to run these tests
token <- Sys.getenv("RS_TOKEN")

# OPTIONAL: you can set a signal id to use in the tests,
#   otherwise it will use the first signal it finds
sig_id <- Sys.getenv("RS_TEST_SIGNAL")