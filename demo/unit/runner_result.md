# Runner::Result

## Setup

Setup the test before each example:

    require 'trix/runner'

    include Trix

    @printer = ->(line) {}
    @result = Runner::Result.new(@printer, 0)

## Output

A result can provide the text printed to stdout and stderr.

    @result << Runner::Line.new(0, "Can we test it?\n")
    @result << Runner::Line.new(1, "Oops!\n")

    @result.output_text.assert == "Can we test it?\n"
    @result.error_text.assert == "Oops!\n"
