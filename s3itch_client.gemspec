# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3itch_client/version'

Gem::Specification.new do |gem|
  gem.name          = "s3itch_client"
  gem.version       = S3itchClient::VERSION
  gem.authors       = ["Matias Korhonen"]
  gem.email         = ["me@matiaskorhonen.fi"]
  gem.description   = %q{Send files to s3itch from the command line}
  gem.summary       = %q{Upload files to S3 via your own s3itch instance}
  gem.homepage      = "https://github.com/k33l0r/s3itch_client"

  gem.add_dependency "i18n", ">= 0.6.1"

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "webmock", "~> 1.8.11"
  gem.add_development_dependency "simplecov", "~> 0.6.4"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
