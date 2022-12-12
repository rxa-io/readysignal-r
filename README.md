# Ready Signal API - R

R wrapper for the Ready Signal API: http://app.readysignal.com

Please direct all questions and/or recommendations to support@readysignal.com

<br>

## Installation

```R
library(devtools)
devtools::install_github("rxa-io/readysignal-r")
```

<br>

## Usage

Your **access token** and **signal ID** can be found on your "Manage Signal" page within the Output information

The **signal ID** is also visible within the URL of the "Manage Signal" page:
```
https://app.readysignal.com/signal/SIGNAL_ID/manage
```

<br>

### Setup

After adding the library, pass your access token to the `init()` function to configure authentication for subsequent requests

```r
library(readysignal)

access_token <- "YOUR_ACCESS_TOKEN"
readysignal::init(access_token)
```

<br>

### Available Functions

Use the built-in `help()` for more details
```r
# for example...
help(signal_to_csv)
```

| Function | Notes |
|-|-|
| `init(`*access_token*`)` | Inititalize the API functions with your access token. This **MUST** be run for the following functions to work
| `list_signals()` | List signals associated with your Ready Signal account |
| `get_signal_details(`*signal_id*`)` | Get signal details |
| `delete_signal(`*signal_id*`)` | Deletes a signal |
| `get_signal(`*signal_id*`)` | Grab signal data as an R DataFrame |
| `signal_to_csv(`*signal_id*, *filename*`)` | Download signal data to a CSV |
| `auto_discover(`*geo_grain*, *filename*, *df*`)` | Upload data to Ready Signal's AutoDiscovery feature. Use `help()` for more details |

<br>

## Examples

```r
library(readysignal)

# using an environment variable is optional but useful
access_token <- Sys.getenv("MY_TOKEN")
readysignal::init(access_token)

# grab list of signals
signals <- list_signals()

# find a signal ID
signal_id <- signals$id[1]

# grab the signal details
details <- get_signal_details(signal_id)
print(details$name)

# grab the signal data as a dataframe...
signal_df <- get_signal(signal_id)
print(dim(signal_df))

# ...or save it directly as a CSV
signal_to_csv(signal_df, 'my_signal.csv')

# create a new signal with the AutoDiscovery feature
# from a dataframe. When geo-grain=Country, columns
# MUST be c("Date", "Value"). When geo-grain=State,
# columns MUST be c("Date", "Value", "State")
df <- data.frame(
    Date=c("2022-01-01", "2022-02-01", "2022-03-01"), 
    Value=c(351, 465, 712)
)
auto_discover(geo_grain="Country", df=df)

# use AutoDiscovery with a file upload, this time we'll
# use a State geo_grain. The file needs the same columns
# as described above
system("cat states.csv") # Date,State,Value
                         # 2020-03-01,TN,416000
                         # 2020-03-01,KY,373000
                         #        ...
resp <- auto_discover(geo_grain="State", filename="states.csv")

# delete a signal (in this case, the one we just created)
delete_signal(resp$signal_id)
```