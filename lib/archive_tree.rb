require 'archive_tree/core'

# +ArchiveTree+ is responsible for the creation of hashes that cronologically represent your model
# based on a provided field
#
# If you wish to take advantage of its functionalities, please use the act_as_archive method in your ActiveRecord Model.
#
# Examples
#   class Post < ActiveRecord::Base
#     act_as_archive # use the created_at
#   end
#
#   class Post < ActiveRecord::Base
#     act_as_archive :published_at # use the published_at
#   end
#
#   Post.archive_tree(:years_and_months => { 2010 => [1] }) #=> { 2010 => { 1 => [Post] } }
#
# TODO: This module should undergo a query optimization. Furthermore, an ORM abstraction.
module ArchiveTree
  def act_as_archive(date_field = :created_at)
    raise ::ArgumentError, "undefined parameter #{date_field.to_s}" unless column = columns_hash[date_field.to_s]
    raise ::ArgumentError, "invalid parameter #{date_field.to_s}" unless column.type == :datetime
    raise ::TypeError, "invalid type" unless self.ancestors.include? ActiveRecord::Base

    @date_field = date_field
    extend Core
  end

  private
    attr_reader :date_field
end # ArchiveTree

ActiveRecord::Base.send :extend, ArchiveTree if defined?(ActiveRecord::Base)