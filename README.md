# Intial Setup

    docker-compose build
    docker-compose up mariadb
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect

    curl -I localhost:3000/abc

# About the encoding algorithm

```
01  def get_short_code_by(num)
02    return nil if num.nil?
03
04    outputs = []
05    value = num
06
07    while value > 0
08      index = value % count
09      outputs.unshift chars[index]
10      value = value / count
11    end
12
13    outputs.join ''
14  end
15
16  private
17
18  def chars
19    ShortUrl::CHARACTERS
20  end
21
22  def count
23    @_count ||= chars.count
24  end
```

```
CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze
```

This function `get_short_code_by(num)` converts decimal number `num` to the new base number.

First we initialize the `value` with the `num`. After that we divide the `value` by `count`, the number of characters in the new base system. The character for remainder will be added to the beginning of `outputs` array and the quotient will be new `value`. We repeat this process until the `value` becomes 0.

# About the decoding algorithm

```
01  def get_number_by(short_code)
02    number = 0
03    step = 1
04
05    short_code.split('').reverse.each_with_index do |char, index|
06      number += step * chars.index(char)
07      step *= count
08    end
09
10    number
11  end
12
13  private
14
15  def chars
16    ShortUrl::CHARACTERS
17  end
18
19  def count
20    @_count ||= chars.count
21  end
```

```
CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze
```

This function `get_number_by(short_code)` converts the 62 base number `short_code` to the decimal number - `number`.

We initialize the `number` with 0 and `step` with 1. `step` represents the decimal value of 1 at specific position in `short_code`. For each digit in the `short_code`, we add the value of each `digit` multiplied by its `step` value to the `number`

Note that we start from reverse order since the last digit has the smallest `step` value.
