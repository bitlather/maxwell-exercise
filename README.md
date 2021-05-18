maxwell-exercise
================

Instructions
------------

Running instructions:

```sh
$ ruby price_calculator.rb

$ ruby price_calculator.rb items="milk,milk, bread,banana,bread,bread,bread,milk,apple"
```

Testing instructions:

```sh
$ ruby price_calculator_test.rb
```

Notes
-----

I tried to match the prompt as closely as possible.

The only bell-and-whistle I added was the ability to pass the input from the command line. This made it easier for me to run during development. If this were a production script, I would have requested this feature during project planning, because arguments are important for automating tasks from the command line. If we were serious about supporting command-line arguments, I would've considered researching libraries to implement this instead of writing `get_command_line_argument(key)`.

One hidden feature I added was tracking unrecognized items in `checkout()` and storing them in `receipt[:unrecognized]`. It could be useful to display such information to the user. However, that was outside of the prompt's spec, so I never displayed it.

I decided to store prices as cents, instead of dollars, to avoid floating point arithmetic issues. For instance, an earlier commit I made calculated the total saved when purchasing two milks as `2.9400000000000004`. Although `printf` can use `"$%.2f"` to format the amount as `$2.94`, the movie Office Space tells us those little fractions can add up so I thought it would be best to avoid them entirely.

The render code, `print_table()`, must format the prices. I indicated this would be an issue for the front-end by suffixing `receipt`'s keys with `_cents`. If this were an API, I'd probably keep the currencies as integers in the back-end when any calculations are performed, then format them as floating-point numbers when the response object is built.

Since no points were awarded for tests, and I wanted to keep this project easy to run, I built my own `assert` function.
