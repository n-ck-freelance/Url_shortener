module ShortUrlsHelper
  def get_short_code_by(num)
    return nil if num.nil?

    outputs = []
    value = num

    while value > 0
      index = value % count
      outputs.unshift chars[index]
      value = value / count
    end

    outputs.join ''
  end

  def get_number_by(short_code)
    number = 0
    step = 1

    short_code.split('').reverse.each_with_index do |char, index|
      number += step * chars.index(char)
      step *= count
    end

    number
  end

  private

  def chars
    ShortUrl::CHARACTERS
  end

  def count
    @_count ||= chars.count
  end
end
