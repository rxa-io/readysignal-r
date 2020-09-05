## Tests

These scripts automate some of the performance testing used during development.

They aren't necessarily formal unit tests, but they are still useful in doing quick bug checks

<br>

## How to Use

1. You'll need a Ready Signal access token, as well as one or more signals created
2. Run each test with `Rscript`, with the appropriate arugments (see below)

| Test Name | Description | Arguments |  
|-----------|-------------|-----------|
| `test_all.R` | Runs all of the following tests | Access Token, Signal ID |
| `test_list_signals.R` | Calls `readysignal::list_signal()`, returns output dimensions and elapsed time | Access Token |
| `test_get_signal.R` | Calls `readysignal::get_signal()`, returns output dimensions and elapsed time | Access Token, Signal ID |
| `test_get_signal_details.R` | Calls `readysignal::get_signal_details()`, returns elapsed time | Access Token, Signal ID |

<br>

## Usage Examples
```bash
# Run "test_get_signals.R"
$ Rscript test_get_signal.R $RS_TOKEN 89
```

<br>

## Notes / Hints
* You need to run these scripts in the `tests/` directory
* Running these tests are much easier if your access token is in an OS environment variable
  ```bash
  # macOS / Linux
  $ export RS_TOKEN="YOUR_TOKEN"
  ```