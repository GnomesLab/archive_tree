require 'spec_helper'

describe ArchiveTree::RailsExt do

  describe "ActiveRecord::Base" do
    it "must have a class method named acts_as_archive" do
      ActiveRecord::Base.should respond_to :acts_as_archive
    end
  end # ActiveRecord::Base

  describe "ActionView::Base" do
    it "must have a instance method named draw_archive_tree" do
      ActionView::Base.new.should respond_to :draw_archive_tree
    end
  end # ActiveRecord::Base

end # ArchiveTree
