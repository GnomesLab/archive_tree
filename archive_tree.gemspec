# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY

  s.name        = 'archive_tree'
  s.version     = '1.0.0'
  s.summary     = 'Creates chronological trees of your models based on column of your choice.'

  s.authors     = ['Diogo Almeida', 'Miguel Teixeira']
  s.email       = ['mail@gnomeslab.com']
  s.homepage    = 'http://github.com/GnomesLab/archive_tree/'

  s.description = "ArchiveTree is a Ruby Gem that makes it easy for you to create beautiful chronological archive trees of your models. For instance, you can create a tree for your blog posts."

  s.required_rubygems_version = '>= 1.3.7'

  s.add_dependency('activerecord', '~> 3.0.1')
  s.add_dependency('actionpack', '~> 3.0.1')

  s.add_development_dependency 'mysql', '~> 2.8.0'
  s.add_development_dependency 'ruby-debug19', '~> 0.11.0'
  s.add_development_dependency 'rspec', '~> 2.0.0'
  s.add_development_dependency 'factory_girl_rails', '~> 1.0.0'
  s.add_development_dependency 'database_cleaner', '~> 0.6.0'

  s.files = Dir['lib/**/*.rb'] + Dir['[A-Z]*'] + Dir['spec/**/*.rb'] + ['init.rb']
  s.require_paths << 'lib'
end
