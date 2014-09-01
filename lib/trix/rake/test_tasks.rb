require 'rake'

module Trix
    module Rake
        # Test tasks
        module TestTasks
            include ::Rake::DSL

            # Install Rake tasks when included
            def self.included(other)
                desc "Run all tests"
                task :test => ['test:demo', 'test:integration']

                namespace :test do
                    desc "Run demos and unit tests"
                    task :demo do
                        sh "qed -p demo"
                    end

                    desc "Run integration tests"
                    task :integration do
                        sh "qed -p integration"
                    end
                end
            end
        end
    end
end

include Trix::Rake::TestTasks
