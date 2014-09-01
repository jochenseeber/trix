require 'ae'

module Trix
    # Helpers for QED testing and documentation
    #
    # @see https://github.com/rubyworks/qed QED Project
    module QED
        # Standard applique functions
        module Standard
            # Remove empty lines, remove leading and trailing spaces and normalize white space
            #
            # @param text [String] Text to clean
            # @return [String] cleaned text
            def clean_text(text)
                raise(ArgumentError, 'Text must not be nil.') if text.nil?

                text.gsub(/\n+/, "\n").gsub(/^\s+|\s+$/, '').gsub(/[ \t]+/, ' ')
            end

            # Set up default rules when included
            def self.included(other)
                other.instance_eval do
                    # Expect the following block as text output
                    When /\bexpression `([^`]+)`[^.]+\bmatches the following text\b[^.]*:/i do |expression, expected|
                        raise(ArgumentError, 'Please supply a block with the text to match') if expected.nil?
                        actual = instance_eval(expression)

                        if actual.is_a?(Enumerable) then
                            actual = actual.join
                        end

                        clean_text(actual).assert == clean_text(expected)
                    end

                    # Expect the following block as text output
                    When /\bvariable `(@?[a-z0-9_]+)`[^.]+\bmatches the following text\b[^.]*:/i do |variable, expected|
                        raise(ArgumentError, 'Please supply a block with the text to match') if expected.nil?
                        actual = instance_variable_get(variable)

                        if actual.is_a?(Enumerable) then
                            actual = actual.join
                        end

                        clean_text(actual).assert == clean_text(expected)
                    end

                    # Setup
                    When /\bbefore each example\b[^.]*:/i do |code|
                        Before do
                            instance_eval(code)
                        end
                    end
                end
            end
        end
    end
end
