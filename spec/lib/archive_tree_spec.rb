require 'spec_helper'

describe ArchiveTree do

  describe "acts_as_archive" do

    it "should raise exception for undefined fields" do
      lambda do
        eval("class Post < ActiveRecord::Base\n acts_as_archive(:dummy)\n end")
      end.should raise_error(ArgumentError)
    end

    it "should raise exception for invalid fields" do
      lambda do
        eval("class Post < ActiveRecord::Base\n acts_as_archive(:body)\n end")
      end.should raise_error(ArgumentError)
    end

  end # acts_as_archive

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

      it "should return the archive tree for all posts" do
        tree = { 2007 => { 1 => [Post.find(21)],
                           2 => [Post.find(22)],
                           3 => [Post.find(23)],
                           4 => [Post.find(24)],
                           5 => [Post.find(25)] },
                 2008 => { 1 => [Post.find(26)],
                           2 => [Post.find(27)],
                           3 => [Post.find(28)],
                           4 => [Post.find(29)],
                           5 => [Post.find(30)] },
                 2009 => { 1 => [Post.find(31)],
                           2 => [Post.find(32)],
                           3 => [Post.find(33)],
                           4 => [Post.find(34)],
                           5 => [Post.find(35)] },
                 2010 => { 1 => [Post.find(36)],
                           2 => [Post.find(37)],
                           3 => [Post.find(38)],
                           4 => [Post.find(39)],
                           5 => [Post.find(40)] } }

        Post.archive_tree.should == tree
      end

    end # default behavior

    describe "years to sweep" do

      it "accepts a years key in the options hash and complies to it" do
        tree = { 2009 => { 1 => [Post.find(51)],
                           2 => [Post.find(52)],
                           3 => [Post.find(53)],
                           4 => [Post.find(54)],
                           5 => [Post.find(55)] },
                 2010 => { 1 => [Post.find(56)],
                           2 => [Post.find(57)],
                           3 => [Post.find(58)],
                           4 => [Post.find(59)],
                           5 => [Post.find(60)] } }

        Post.archive_tree(:years => [2009, 2010]).should == tree
      end

    end # years to sweep

    describe "months to sweep" do

      it "should only sweep January" do
        tree = { 2007 => { 1 => [Post.find(61)] },
                 2008 => { 1 => [Post.find(66)] },
                 2009 => { 1 => [Post.find(71)] },
                 2010 => { 1 => [Post.find(76)] } }

        Post.archive_tree(:months => [1]).should == tree
      end

    end # months to sweep

    describe "years and months" do

      it "should comply with the requested years and months filter" do
        tree = { 2007 => { 1 => [Post.find(81)] },
                 2008 => { 2 => [Post.find(87)], 3 => [Post.find(88)] } }

        Post.archive_tree(:years_and_months => { 2007 => [1], 2008 => [2, 3] }).should == tree
      end

    end # years and months

  end # archive_tree

end # ArchiveTree
