require 'active_record'
require 'action_view'
require 'archive_tree'

# Extending Rails Classes
ActiveRecord::Base.send :extend, ArchiveTree if defined?(ActiveRecord::Base)
ActionView::Base.send :include, ArchiveTree::ActionViewExtensions if defined?(ActionView::Base)
