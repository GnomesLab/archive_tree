module ArchiveTree

  module ActionViewExtensions
    autoload :DrawArchiveTree, 'archive_tree/action_view_extensions/draw_archive_tree'
    ::ActionView::Base.send :include, DrawArchiveTree
  end # ActionViewExtensions

end # ArchiveTree
