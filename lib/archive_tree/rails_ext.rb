module ArchiveTree

  module RailsExt # :nodoc:

    autoload :ActionView, 'archive_tree/rails_ext/action_view'
    autoload :ActiveRecord, 'archive_tree/rails_ext/active_record'

  end # RailsExt

end # ArchiveTree

# Extending Rails
ActiveRecord::Base.send :extend, ArchiveTree
ActionView::Base.send :include, ArchiveTree::RailsExt::ActionView::Helper
