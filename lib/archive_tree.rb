# +ArchiveTree+ is responsible for the creation of hashes that cronologically represent your model
# based on a provided field
#
# If you wish to take advantage of its functionalities, please use the acts_as_archive method in your ActiveRecord Model.
#
# Examples
#   class Post < ActiveRecord::Base
#     acts_as_archive # uses +created_at+ by default
#   end
#
#   class Post < ActiveRecord::Base
#     acts_as_archive :published_at # uses +published_at+ instead of +created_at+ (default)
#   end
#
#   Post.archive_tree(:years_and_months => { 2010 => [1] }) #=> { 2010 => { 1 => [Post] } }
#
# TODO: This module should undergo a query optimization. Furthermore, an ORM abstraction.
module ArchiveTree

  autoload :Core, 'archive_tree/core'

  def acts_as_archive(date_field = :created_at)
    raise ::ArgumentError, "undefined parameter #{date_field.to_s}" unless column = columns_hash[date_field.to_s]
    raise ::ArgumentError, "invalid parameter #{date_field.to_s}"   unless column.type == :datetime

    self.date_field = date_field # Stores the date column

    extend Core
  end

  private
    attr_accessor :date_field

end # ArchiveTree

ActiveRecord::Base.send :extend, ArchiveTree if defined?(ActiveRecord::Base)
