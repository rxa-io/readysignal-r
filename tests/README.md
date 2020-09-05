## Tests

These scripts automate some of the performance testing used during development. They aren't necessarily formal unit tests, but they are still useful in doing quick bug checks.

<br>

## How to Use

You'll need a Ready Signal access token, as well as one or more signals created.

A separate test file is provided for the basic functions of this library, so you can test each function individually by calling that script. 

**NOTE**: you need to run these scripts in the `tests/` directory.

**HINT**: running these tests are much easier if your access token is in an OS environment variable

<br>

## Usage Examples

* **Get Signal**
  ```
  $ Rscript test_get_signal.R $RS_TOKEN 89
  ```

<br>

## More Tests Coming Soon!