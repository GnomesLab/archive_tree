require 'spec_helper'

describe ArchiveTree do

  describe "acts_as_archive" do

    it "should raise exception for undefined fields" do
      lambda do
        class Post < ActiveRecord::Base
          acts_as_archive :dummy
        end
      end.should raise_error(ArgumentError)
    end

    it "should raise exception for invalid fields" do
      lambda do
        class Post < ActiveRecord::Base
          acts_as_archive :body
        end
      end.should raise_error(ArgumentError)
    end

    it "should extend the model with ArchiveTree::RailsExt::ActiveRecord::Scopes methods" do
      Post.should respond_to *ArchiveTree::RailsExt::ActiveRecord::Scopes.instance_methods
    end

  end # acts_as_archive

end # ArchiveTree
