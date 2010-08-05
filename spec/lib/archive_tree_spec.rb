require 'spec_helper'

context ArchiveTree do

  describe "archive tree" do

    before :each do
      [2007, 2008, 2009, 2010].each do |year|
        5.times { |i| Factory.create(:post, :created_at => "#{year}-#{01 + i}-01 00:00:00") }
      end
    end

    describe "default behavior" do
      it "should return an empty hash when there are no records" do
        Post.destroy_all

        Post.archive_tree.should == {}
      end
    end

  end # archive_tree

end # ArchiveTree
