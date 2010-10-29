require 'spec_helper'

describe ArchiveTree do

  describe "self included" do

    it "should extend klass with its ArchiveTree::Core" do
      [:archived_years, :archived_months, :archive_tree, :archive_node].each do |method|
        Post.should respond_to method
      end
    end
  end # self.included

end # ArchiveTree
