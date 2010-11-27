# +ArchiveTree+ helps you creating cronological representations of your model.
#
# This module will extend ActiveRecord adding the +acts_as_archive+ method so you could specify what column you want
# to use in the cronological representation.
#
# Since you probably want to show this cronological representation in a HTML page, the module also adds the
# +draw_archive_tree+ method to ActionView so you could easily get the HTML tree in your views.
#
# Example usage:
#
#   Configure your model:
#   class Post < ActiveRecord::Base
#     acts_as_archive
#   end
#
#   Render the HTML tree:
#   <%= draw_archive_tree :post %>
#
# TODO: This module should undergo a query optimization. Furthermore, an ORM abstraction.
module ArchiveTree

  require 'archive_tree/rails_ext'

  # Class method that will add the scopes methods to your model.
  #
  # Parameters:
  #   * date_field #=> The datetime column that should be used in the cronological representations
  #
  # Defaults:
  #   * date_field #=> Uses the created_at column
  #
  # Example:
  #   class Post < ActiveRecord::Base
  #     acts_as_archive :created_at
  #   end
  def acts_as_archive(date_field = :created_at)
    raise ::ArgumentError, "undefined parameter #{date_field.to_s}" unless column = columns_hash[date_field.to_s]
    raise ::ArgumentError, "invalid parameter #{date_field.to_s}"   unless column.type == :datetime

    self.date_field = date_field # Stores the date column

    extend RailsExt::ActiveRecord::Scopes
  end

  private
    attr_accessor :date_field

end # ArchiveTree
