# ReadySignal API - R
This library is designed to be a wrapper for the ReadySignal API: http://app.readysignal.com

Please direct all questions and/or recommendations to jess.brown@rxa.io.

<br>

## Installation

```R
library(devtools)
devtools::install_github("rxa-io/readysignal-r")
```

<br>

## Usage

Your **access token** and **signal ID** can be found on your "Manage Signal" page within the Output information.

Your signal ID is also visible within the URL of the "Manage Signal" page:
```
https://...readysignal.com/signal/SIGNAL_ID/manage
```

<br>

### Setup

```r
library(readysignal)

access_token <- "YOUR_ACCESS_TOKEN"
signal_id <- 123 # (your signal ID)
```

<br>

### List Signals

Using your ```access_token```, you can list all signals and metadata that are associated with your ReadySignal account.

```r
list_signals(access_token)
```

<br>

### Signal Details

Using your ```access_token``` and your ```signal_id``` you can view the details of a specific signal.

```r
get_signal_details(access_token, signal_id)
```

<br>

### Signal Data
There are two different ways to receive your signal data:
* R data.frame
* CSV export

#### data.frame
```r
df <- get_signal(access_token, signal_id)
```

#### CSV export 
```r
signal_to_csv(access_token, signal_id, "my_signal.csv")
```

<br>

## Help

Use the built-in `help()` command to view function descriptions, etc.
```r
help(signal_to_csv)
```