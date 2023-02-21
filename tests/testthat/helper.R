#
# NOTE:
#   The Ready Signal API is best tested with a "live" account.
#   To run useful tests, you'll need to set your access token
#   as an environment variable. Otherwise, a few tests that
#   essentially check function signatures will run, but they
#   provide any real insights
#

# access token
token <- Sys.getenv("RS_TOKEN")

# you can set a signal id to use in the tests,
# otherwise it will use the first signal it finds
sig_id <- Sys.getenv("RS_TEST_SIGNAL")

# this is used to determine which tests can be run
authenticated <- token != ""