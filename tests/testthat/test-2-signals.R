test_that("List Signals No Arguments", {
    expect_error(list_signals())
})

if (authenticated) {
    test_that("List Signals", {
        signals <- list_signals(token)
        expect_gt(nrow(signals), 0)
        if (nrow(signals) > 0) {
            if (sig_id == "") {
                sig_id <<- signals$id[1]
            }
        }
    })

    test_that("Signal Details", {
        expect_no_error(get_signal_details(token, sig_id))
    })

    test_that("Get Signal", {
        expect_no_error(get_signal(token, sig_id))
    })

    test_that("Signal to CSV", {
        file <- "out.csv"
        expect_no_error(signal_to_csv(token, sig_id, file))
        if (file.exists(file)) {
            file.remove(file)
        }
    })
}