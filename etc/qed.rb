QED.configure 'demo' do |config|
    require 'coveralls'
    require 'simplecov'

    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
        SimpleCov::Formatter::HTMLFormatter,
        Coveralls::SimpleCov::Formatter
    ]

    SimpleCov.refuse_coverage_drop
    SimpleCov.command_name 'QED'

    SimpleCov.start do
        coverage_dir 'log/coverage'
    end

    config.files = ['README.md', 'demo/doc', 'demo/unit']
end

QED.configure 'integration' do |config|
    config.files = ['demo/integration']
end
