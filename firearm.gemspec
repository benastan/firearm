# -*- encoding: utf-8 -*-
require File.expand_path('../lib/firearm/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["benastan"]
  gem.email         = ["bennyjbergstein@gmail.com"]
  gem.description   = ""
  gem.summary       = ""
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "firearm"
  gem.require_paths = ["lib"]
  gem.version       = Firearm::VERSION

  gem.add_dependency 'commander'
  gem.add_dependency 'jekyll'
  gem.add_dependency 'haml'
  gem.add_dependency 'compass'
  gem.add_dependency 'sass'
  gem.add_dependency 'coffee-script'
  gem.add_dependency 'bootstrap-sass'
  gem.add_dependency 'jekyll-assets'
  gem.add_dependency 'psych'
end
