test_that("Missing Token", {
    expect_error(list_signals())
})

test_that("Invalid Token", {
    bad_token <- "bad_token!"
    expect_error(list_signals(bad_token))
})

if (authenticated) {
    test_that("Correct Token", {
        expect_no_error(list_signals(token))
    })
}