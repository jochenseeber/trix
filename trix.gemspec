# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trix/version'

Gem::Specification.new do |spec|
    spec.name = 'trix'
    spec.version = Trix::VERSION
    spec.authors = ['Jochen Seeber']
    spec.email = ['jochen@seeber.me']
    spec.summary = 'Trix is a collection of useful Ruby tools'
    spec.description = 'Easy peasy!'
    spec.homepage = 'https://github.com/jochenseeber/trix'
    spec.license = 'AGPL-3.0'
    spec.metadata = {
        'issue_tracker' => 'https://github.com/jochenseeber/trix/issues',
        'source_code' => 'https://github.com/jochenseeber/trix',
        'documentation' => 'http://rubydoc.info/gems/trix/frames',
        'wiki' => 'https://github.com/jochenseeber/trix/wiki'
    }

    spec.files = Dir['README.md', 'LICENSE.txt', '.yardopts', 'lib/**/*.rb', 'demo/**/*.{md,rb}']
    spec.require_paths = ['lib']

    spec.required_ruby_version = '>= 1.9'

    spec.add_development_dependency 'bundler', '~> 1.7'
    spec.add_development_dependency 'rake', '~> 10.3'
    spec.add_development_dependency 'qed', '~> 2.9'
    spec.add_development_dependency 'ae', '~> 1.8'
    spec.add_development_dependency 'yard', '~> 0.8'
    spec.add_development_dependency 'coveralls', '~> 0.7'
end
