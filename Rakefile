require 'rake'
require 'rake/rdoctask'
require 'rake/gempackagetask'

desc 'Generate documentation for the archive_tree plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ArchiveTree'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.ruby_opts = '-w'
  end

  task :default => :spec
rescue LoadError
  raise 'RSpec could not be loaded. Run `bundle install` to get all development dependencies.'
end

# Rubygems
namespace :rubygems do
  gemspec = eval(File.read('archive_tree.gemspec'))
  Rake::GemPackageTask.new(gemspec) do |pkg|
    sh "rake spec"
    pkg.gem_spec = gemspec
  end

  desc "build the gem and release it to rubygems.org"
  task :release => :gem do
    sh "gem push pkg/archive_tree-#{gemspec.version}.gem"
  end
end
