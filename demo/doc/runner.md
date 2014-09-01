# Runner

A runner is a component that can execute Ruby code with redirected output.

## Set up a new runner

To set up a runner, use the following code before each example:

    require 'trix/runner'

    @runner = Trix::Runner.new(Trix::Runner::QUIET_MODE)

## Redirect standard output

Create a new runner and use it to run some code that prints to stdout.

    @result = @runner.run do
        STDOUT.puts "Easy peasy!"
    end

The expression `@result.text` now matches the following text:

    Easy peasy!

## Redirect standard error

Create a new runner and use it to run some code that prints to stdout.

    @result = @runner.run do
        STDERR.puts "Easy peasy!"
    end

The expression `@result.text` now matches the following text:

    Easy peasy!

## Process output

Create a new runner and use it process the output

    @output = ''

    @runner = Trix::Runner.new(Trix::Runner::QUIET_MODE) do |line|
        @output << line.text
    end

    @result = @runner.run do
        puts "Easy peasy!"
    end

The variable `@output` now matches the following text:

    Easy peasy!

## Redirect external program calls

Create a new runner and use it to redirect the output of an external program

    @result = @runner.execute('echo', 'Easy peasy!')

The expression `@result.text` now matches the following text:

    Easy peasy!

## Redirect stderr for external program calls

Create a new runner and use it to redirect the output of an external program

    @result = @runner.execute('sh', '-c', 'echo "Easy peasy!" 1>&2')

The expression `@result.text` now matches the following text:

    Easy peasy!

## Unit tests

You can also have a look at the [unit tests](runner_test.md).
