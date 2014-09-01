require 'shellwords'

module Trix
    # Runner component that you can use to run Ruby code and external programs with redirected output
    class Runner
        # Output target for captured output
        class Output
            # @return [IO] Underlying stream to read the output from
            attr_reader :out

            # @return [Integer] Output level to distinguish what stream this output captures, stdout or stderr
            attr_reader :level

            # @return [Runner::Line] Current unfinished line
            attr_reader :line

            # Initialize a new Output object
            #
            # @param result [Runner::Result] Result object to collect the captured lines
            # @param out [IO] Unerlying stream to read the output from
            # @param level [Integer] Output level to distinguish what stream this output captures, stdout or stderr
            def initialize(result, out, level)
                @result = result
                @out = out
                @level = level
                @line = nil
            end

            # Append text to this output
            #
            # Creates a line object for each line in the text and appends it to the result object. If there is an
            # unfinished line, the text is appended to it before a new line object is created.
            #
            # @param arg [String] Text to append
            def <<(arg)
                arg.lines.each do |text|
                    if @line.nil? then
                        @line = Line.new(@level, text)
                    else
                        @line << text
                    end

                    if text.end_with?("\n") then
                        @result << @line
                        @line = nil
                    end
                end
            end

            # Return the underlying IO object
            #
            # @return [IO] IO object
            def to_io
                return @out
            end

            # Close the output
            def close
                @out.close

                if not @line.nil? then
                    @result << @line
                    @line = nil
                end
            end
        end

        # Captured line of output
        class Line
            # @return [Integer] Output level to distinguish where the otuptu came from, stdout or stderr
            attr_reader :level

            # @return [String] Captured text including trailing newline
            attr_reader :text

            # Initialize a new line
            #
            # @param level [Integer] Output level to distinguish where the otuptu came from, stdout or stderr
            # @param text [String] Captured text including trailing newline
            def initialize(level, text)
                @level = level
                @text = text
            end

            # Append text to the line
            #
            # @param text [String] Text
            def <<(text)
                @text << text
            end

            # Return the type of the line
            #
            # @return [Symbol] either :stdout or :stderr
            def type
                TYPES[@level]
            end

            # Convert the line to a string
            #
            # Returns the text of the line.
            #
            # @return [String] Line text
            def to_s
                @text
            end
        end

        # Result of the redirected code
        class Result
            # @return [Array<Runner::Line>] Captured output lines
            attr_reader :lines

            # @return [Object] Result of the redirected block
            attr_accessor :value

            # Initialize a new result
            #
            # @param printer [Proc] Proc to process each captured line
            # @param autoshow [Integer] Flag to determine if output to a stream leaves quiet mode
            def initialize(printer, autoshow)
                @printer = printer
                @quiet = true
                @lines = []
                @autoshow = autoshow
            end

            # Append a line of output
            #
            # Appends a line to the captured output and notifies the configured printer proc.
            #
            # @param line [Runner::Line] Line to append
            def <<(line)
                @lines << line
                @printer.call(line)

                if @quiet and (line.level & @autoshow) != 0 then
                    unmute
                end
            end

            # Unmutes the result
            #
            # Leaves quiet mode and prints all the output that was not printed so far.
            def unmute
                if @quiet then
                    @quiet = false
                    @lines.each do |line|
                        print line.text
                    end
                end
            end

            # Get the captured text
            def text
                @lines.map {|l| l.text}.join
            end

            # Get the captured text written to stdout
            def output_text
                @lines.select{|l| l.type == :stdout}.map{|l| l.text}.join
            end

            # Get the captured text written to stdout
            def error_text
                @lines.select{|l| l.type == :stderr}.map{|l| l.text}.join
            end
        end

        # Output mode
        Mode = Struct.new(:name, :autoshow)

        # Quiet mode (never print any output)
        QUIET_MODE = Mode.new(:quiet, [])

        # Output mode (print output if something is written to stdout)
        OUTPUT_MODE = Mode.new(:output, [:stdout]),

        # Error mode (print output if something is written to stderr)
        ERROR_MODE = Mode.new(:error, [:stderr]),

        # Noisy mode (print output if something is written to stdout or stderr)
        NOISY_MODE = Mode.new(:noisy, [:stdout, :stderr])

        # Output types
        TYPES = [:stdout, :stderr]

        # Output levels (a number representing each output type)
        LEVELS = Hash[TYPES.collect.with_index{|t, i| [t, i]}]

        # Initialize a new runner
        #
        # @param mode [Runner::Mode] Output mode
        # @yield Block that is called for each line of captured output
        # @yieldparam line [Runner::Line] Captured line
        def initialize(mode = ERROR_MODE, &printer)
            @printer = printer || ->(line) {}
            @autoshow = mode.autoshow.map {|s| LEVELS[s] || 0}.inject(:|) || 0
        end

        # Redirect a stream to a pipe
        #
        # @param stream [IO] Stream to redirect
        # @yield Code to run with redirected stream
        # @yieldparam read_stream [IO] Stream to read redirected output from. You are responsible for closing this
        #   stream.
        # @return [Object] Result returned by the block
        def redirect(stream)
            old_stream = stream.clone
            read_stream, write_stream = IO.pipe
            stream.reopen(write_stream)

            begin
                result = yield(read_stream)
            ensure
                stream.reopen(old_stream)
                old_stream.close
                write_stream.close
            end

            result
        end

        # Run a block with redirected STDOUT and STDERR
        #
        # @yield Block to run with redirected output
        # @return [Object] Result returned by the block
        def run
            result = Result.new(@printer, @autoshow)
            thread = nil

            begin
                redirect(STDOUT) do |read_stdout|
                    redirect(STDERR) do |read_stderr|
                        thread = Thread.new do
                            listen(result, read_stdout, read_stderr)
                        end

                        result.value = yield
                    end
                end
            ensure
                if not thread.nil? then
                    thread.join
                end
            end

            result
        end

        # Execute an external command with redirected stdout and stderr
        #
        # @param command [Array<String>] Command
        # @return [Process::Status] Process status
        def execute(*command)
            run do
                system Shellwords.join(command)
                $?
            end
        end

        # Capture redirected output
        #
        # @param result [Runner::Result] Result object to store output
        # @param stdout [IO] Stream to read stdout from
        # @param stderr [IO] Stream to read stderr from
        def listen(result, stdout, stderr)
            streams = [
                Output.new(result, stdout, LEVELS[:stdout]),
                Output.new(result, stderr, LEVELS[:stderr])
            ]

            until streams.empty? do
                selected, = IO::select(streams, nil, nil, 0.1)

                if not selected.nil? then
                    selected.each do |stream|
                        if stream.to_io.eof? then
                            streams.delete(stream)
                            stream.close
                        else
                            data = stream.to_io.readpartial(1024)
                            stream << data
                        end
                    end
                end
            end
        end
    end
end
