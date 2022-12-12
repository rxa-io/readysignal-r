source("../R/readysignal.R")

# API Call Before Init
tryCatch({
    list_signals()
    cat("❌ API Call Before Init (no error thrown)\n")
}, error = function(e) {
    cat("✅ API Call Before Init (expected error)\n")
})

# Init, No Token
tryCatch({
    init()
    cat("❌ Init, No Token (no error thrown)\n")
}, error = function(e) {
    cat("✅ Init, No Token (expected error)\n")
})

# Init, Blank Token
tryCatch({
    init("")
    cat("❌ Init, Blank Token (no error thrown)\n")
}, error = function(e) {
    cat("✅ Init, Blank Token (expected error)\n")
})

# Init, Invalid Token
tryCatch({
    init("BAD_TOKEN!")
    cat("❌ Init, Invalid Token (no error thrown)\n")
}, error = function(e) {
    cat("✅ Init, Invalid Token (expected error)\n")
})

# Init, Good Token
tryCatch({
    init(Sys.getenv("RS_TOKEN"))
    cat("✅ Init, Good Token (no error)\n")
}, error = function(e) {
    cat("❌ Init, Good Token (error thrown)\n")
    stop("Provide a valid token to run all tests")
})


# Auto Disco, No Args
tryCatch({
    auto_discover()
    cat("❌ Auto Disco, No Args (no error thrown)\n")
}, error = function(e) {
    cat("✅ Auto Disco, No Args (expected error)\n")
})

# Auto Disco, Bad Grain
tryCatch({
    auto_discover(geo_grain = "City", filename = "cities.csv")
    cat("❌ Auto Disco, Bad Grain (no error thrown)\n")
}, error = function(e) {
    cat("✅ Auto Disco, Bad Grain (expected error)\n")
})

# Auto Disco, Missing Data
tryCatch({
    auto_discover(geo_grain = "State")
    cat("❌ Auto Disco, Missing Data (no error thrown)\n")
}, error = function(e) {
    cat("✅ Auto Disco, Missing Data (expected error)\n")
})

# Auto Disco, State DF Missing Columns
tryCatch({
    df <- read.csv("states.csv")
    df <- df[1:2]
    ids <- auto_discover(geo_grain = "State", df = df)$signal_id
    if (is.null(ids)) stop()
    cat("❌ Auto Disco, State DF Missing Columns (no error thrown)\n")
}, error = function(e) {
    cat("✅ Auto Disco, State DF Missing Columns (expected error)\n")
})

# Auto Disco, State DF (Array) Upload
tryCatch({
    df <- read.csv("states.csv")
    s1 <<- auto_discover(geo_grain = "State", df = df)$signal_id
    cat("✅ Auto Disco, State DF (Array) Upload (no error)\n")
}, error = function(e) {
    cat("❌ Auto Disco, State DF (Array) Upload (error thrown)\n")
})

# Auto Disco, Country DF (Array) Upload
tryCatch({
    df <- read.csv("country.csv")
    s2 <<- auto_discover(geo_grain = "Country", df = df)$signal_id
    cat("✅ Auto Disco, Country DF (Array) Upload (no error)\n")
}, error = function(e) {
    cat("❌ Auto Disco, Country DF (Array) Upload (error thrown)\n")
})

# Auto Disco, State File Upload
tryCatch({
    s3 <<- auto_discover(geo_grain = "State", filename = "states.csv")$signal_id
    cat("✅ Auto Disco, State File Upload (no error)\n")
}, error = function(e) {
    cat("❌ Auto Disco, State File Upload (error thrown)\n")
})

# Auto Disco, Country File Upload
tryCatch({
    s4 <<- auto_discover(geo_grain = "Country", filename = "country.csv")$signal_id
    cat("✅ Auto Disco, Country File Upload (no error)\n")
}, error = function(e) {
    cat("❌ Auto Disco, Country File Upload (error thrown)\n")
})

cat("🕑 waiting for 120 seconds for signal processing\n")
Sys.sleep(120)

# List Signals
tryCatch({
    df <- list_signals()
    df <- df[df$id %in% c(s1, s2, s3, s4), ]
    if (nrow(df) != 4) stop()
    cat("✅ List Signals (no error)\n")
}, error = function(e) {
    cat("❌ List Signals (error thrown)\n")
})

# Get Signal Details
tryCatch({
    df <- get_signal_details(s1)
    if (length(df) <= 0) stop()
    cat("✅ Get Signal Details (no error)\n")
}, error = function(e) {
    cat("❌ Get Signal Details (error thrown)\n")
})

# Get Signal
tryCatch({
    df <- get_signal(s1)
    if (nrow(df) <= 0) stop()
    cat("✅ Get Signal (no error)\n")
}, error = function(e) {
    cat("❌ Get Signal (error thrown)\n")
})

# Save Signal to CSV
tryCatch({
    signal_to_csv(s1, "delete.csv")
    file.remove("delete.csv")    
    cat("✅ Save Signal to CSV (no error)\n")
}, error = function(e) {
    cat("❌ Save Signal to CSV (error thrown)\n")
})

# Delete Signals
tryCatch({
    delete_signal(s1)
    delete_signal(s2)
    delete_signal(s3)
    delete_signal(s4)
    cat("✅ Delete Signals (no error)\n")
}, error = function(e) {
    cat("❌ Delete Signals (error thrown)\n")
})
