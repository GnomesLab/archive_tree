require 'spec_helper'

context ArchiveTree do

  describe "self included" do

    it "should extend klass with its ArchiveTree::ClassMethods" do
      [:archived_years, :archived_months, :archive_tree].each do |method|
        Post.should respond_to method
      end
    end # class methods

  end # self.included

end # ArchiveTree
