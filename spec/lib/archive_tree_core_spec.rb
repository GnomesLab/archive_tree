require 'spec_helper'

describe ArchiveTree do

  describe "self included" do

    it "should extend klass with its ArchiveTree::Core" do
      [:archived_years, :archived_months, :archive_tree].each do |method|
        Post.should respond_to method
      end
    end

    it "should raise exception for undefined fields" do
      lambda do
        eval("class Post < ActiveRecord::Base\n act_as_archive(:dummy)\n end")
      end.should raise_error(ArgumentError)
    end

    it "should raise exception for invalid fields" do
      lambda do
        eval("class Post < ActiveRecord::Base\n act_as_archive(:body)\n end")
      end.should raise_error(ArgumentError)
    end

    it "should raise exception for invalid objects" do
      lambda do
        eval("class Post\n act_as_archive\n end")
      end.should raise_error(TypeError)
    end
  end # self.included

end # ArchiveTree
