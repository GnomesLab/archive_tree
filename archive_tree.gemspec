# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY

  s.name        = "archive_tree"
  s.version     = '1.0.0.beta.1'
  # TODO: add the gem summary text
  s.summary     = "TODO"

  s.authors     = ["Diogo Almeida"]
  s.email       = ["diogo.almeida@gnomeslab.com"]
  s.homepage    = "http://github.com/GnomesLab/archive_tree/"

  # TODO: add the gem description text
  s.description = "TODO"

  s.required_rubygems_version = ">= 1.3.7"

  s.add_dependency(%q<activerecord>, [">= 3.0.0.rc"])

  s.add_development_dependency "rspec"
  s.add_development_dependency "database_cleaner"

  s.files        = Dir.glob("{lib}/**/*") + %w(MIT-LICENSE README.md)
  s.require_path = 'lib'
end
