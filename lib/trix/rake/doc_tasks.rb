require 'yard'
require 'rake'

module Trix
    module Rake
        # Documentation tasks
        module DocTasks
            include ::Rake::DSL

            # Install Rake tasks when included
            def self.included(other)
                namespace :doc do
                    desc "Run documentation statistics"
                    task :stats do
                        sh "yard --stats --list-undoc"
                    end
                end

                YARD::Rake::YardocTask.new(name = :doc)
            end
        end
    end
end

include Trix::Rake::DocTasks
