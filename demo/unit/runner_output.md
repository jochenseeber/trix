# Runner::Output

## Setup

Setup the test before each example:

    require 'trix/runner'

    include Trix

    @printer = ->(line) {}
    @result = Runner::Result.new(@printer, 0)
    @out = StringIO.new('', 'w')
    @output = Runner::Output.new(@result, @out, 0)

## Output

A line can be appended to the output.

    @output << "Easy peasy!\n"

    @output.line.assert.nil?
    @result.lines.size.assert == 1
    @result.lines[0].text.assert == "Easy peasy!\n"

Multiple lines can be appended to the output.

    @output << "Can we test it?\nEasy peasy!\n"

    @output.line.assert.nil?
    @result.lines.size.assert == 2
    @result.lines[0].text.assert == "Can we test it?\n"
    @result.lines[1].text.assert == "Easy peasy!\n"

Partial lines can be appended to the output.

    @output << "Can we test it?"
    @output << " Easy peasy!\n"

    @output.line.assert.nil?
    @result.lines.size.assert == 1
    @result.lines[0].text.assert == "Can we test it? Easy peasy!\n"

## Closing

Pending unfinished lines are captured when the output is closed.

    @output << "Easy peasy!"
    @output.close

    @output.line.assert.nil?
    @result.lines.size.assert == 1
    @result.lines[0].text.assert == "Easy peasy!"
