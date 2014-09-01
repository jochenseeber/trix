# Runner::Line

## Setup

Setup the test before each example:

    require 'trix/runner'

    include Trix

## Text

Text can be appended to a line

    line = Runner::Line.new(0, 'Easy')
    line << ' peasy!'
    line.to_s.assert == 'Easy peasy!'

## Miscellaneous

A line knows its output type.

    line = Runner::Line.new(0, 'Easy peasy!')
    line.type.assert == :stdout

    line = Runner::Line.new(1, 'Easy peasy!')
    line.type.assert == :stderr

A line can be converted to a string.

    line = Runner::Line.new(0, 'Easy peasy!')
    line.to_s.assert == 'Easy peasy!'

    line = Runner::Line.new(1, 'Easy peasy!')
    line.to_s.assert == 'Easy peasy!'
