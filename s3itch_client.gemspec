# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3itch_client/version'

Gem::Specification.new do |gem|
  gem.name          = "s3itch_client"
  gem.version       = S3itchClient::CLI::VERSION
  gem.authors       = ["Matias Korhonen"]
  gem.email         = ["matias@kiskolabs.com"]
  gem.description   = %q{Send files to s3itch from the command line}
  gem.summary       = %q{Upload files to S3 via your own s3itch instance}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
