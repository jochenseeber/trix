# Trix

[![Gem Version](https://badge.fury.io/rb/trix.png)](http://badge.fury.io/rb/trix)
[![Build Status](https://travis-ci.org/jochenseeber/trix.png?branch=master)](https://travis-ci.org/jochenseeber/trix)
[![Coverage Status](https://coveralls.io/repos/jochenseeber/trix/badge.png?branch=master)](https://coveralls.io/r/jochenseeber/trix?branch=master)
[![Inline docs](http://inch-ci.org/github/jochenseeber/trix.png?branch=master)](http://inch-ci.org/github/jochenseeber/trix)

Trix is a collection of useful Ruby utilities.

Currently it contains a very flexible and easy to use runner component that allows you to redirect stdout and stderr for
Ruby code and calls to external programs.

So at least someday it will be a collection :smiley:

Of hopefully useful utilities :smiley:

## Runner

With the runner component, you can execute external programs and redirect stdout and stderr. Its main features are

* Captures output to stdout and stderr in order instead of separately
* Automatically can print output in addition to capturing it
* Different modes to e.g. start silently and only print the output if something is printed to stderr
* Can provide you with each line of output for custom processing
* Redirects STDOUT and STDERR instead of only $stdout and $stderr (there is a [difference](http://stackoverflow.com/questions/6671716/what-is-the-difference-between-rubys-stdout-and-stdout))

To use it, just create a new Runner object and call its run method with a block of Ruby code.

    require 'trix/runner'

    runner = Trix::Runner.new

    @result = runner.run do
        # Print text
        puts 'Easy peasy!'
        # Print text to STDERR
        STDERR.puts 'Easy peasy!'
        # Call external program to print to stdout
        system 'echo "Easy peasy!"'
        # Call external program to print to stderr
        system 'echo "Easy peasy!" 1>&2'
        $?
    end

The expression `@result.text` now matches the following text:

    Easy peasy!
    Easy peasy!
    Easy peasy!
    Easy peasy!

The runner will return a result object containing the output lines and result of the redirected block.

You can find a detailed usage description and more examples [here](demo/doc/runner.md).

## Installation

Add this line to your application's Gemfile:

    gem 'trix'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trix

## Contributing

1. Fork the GitHub repository: [https://github.com/jochenseeber/trix/fork](https://github.com/jochenseeber/trix/fork)
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a new Pull Request
