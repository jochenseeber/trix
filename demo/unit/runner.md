# Runner

A runner is a component that can execute Ruby code with redirected output.

## Setup

Setup the test before each example:

    require 'trix/runner'
    require 'set'

    include Trix

    @runner = Runner.new

## Leave no open streams behind

Create a new runner and check if it leaves open streams behind.

    streams_before = Set.new(ObjectSpace.each_object(IO)).delete_if {|s| s.closed?}

    @runner.run do
        puts "Easy peasy!"
    end

    streams_after = Set.new(ObjectSpace.each_object(IO)).delete_if {|s| s.closed?}

    (streams_after - streams_before).size.assert == 0

## Leave no open streams when an error occurs

Create a new runner and check if it leaves open streams behind when an error is raised.

    streams_before = Set.new(ObjectSpace.each_object(IO)).delete_if {|s| s.closed?}

    RuntimeError.assert.raised? do
        @runner.run do
            raise "Hell"
        end
    end

    streams_after = Set.new(ObjectSpace.each_object(IO)).delete_if {|s| s.closed?}

    (streams_after - streams_before).size.assert == 0
