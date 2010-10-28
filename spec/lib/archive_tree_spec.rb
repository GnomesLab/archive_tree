require 'spec_helper'

describe ArchiveTree do

  describe "acts_as_archive" do

    it "should be a class method of ActiveRecord::Base" do
      ActiveRecord::Base.should respond_to :acts_as_archive
    end

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
        tree = {}
        [2007, 2008, 2009, 2010].each_with_index do |year, year_index|
          tree[year] = {}
          0.upto(4).each { |i| tree[year][i+1] = [Post.find(Post.first.id + year_index*5 + i)] }
        end

        Post.archive_tree.should == tree
      end

    end # default behavior

    describe "years to sweep" do

      it "accepts a years key in the options hash and complies to it" do
        tree = {}
        [2009, 2010].each_with_index do |year, year_index|
          tree[year] = {}
          0.upto(4).each { |i| tree[year][i+1] = [Post.find(10 + Post.first.id + year_index*5 + i)] }
        end

        Post.archive_tree(:years => [2009, 2010]).should == tree
      end

    end # years to sweep

    describe "months to sweep" do

      it "should only sweep January" do
        tree = {}
        [2007, 2008, 2009, 2010].each_with_index do |year, year_index|
          tree[year] = {}
          tree[year][1] = [Post.find(Post.first.id + year_index*5)]
        end

        Post.archive_tree(:months => [1]).should == tree
      end

    end # months to sweep

    describe "years and months" do

      it "should comply with the requested years and months filter" do
        tree = { 2007 => { 1 => [Post.find(Post.first.id)] },
                 2008 => { 2 => [Post.find(Post.first.id + 6)], 3 => [Post.find(Post.first.id + 7)] } }

        Post.archive_tree(:years_and_months => { 2007 => [1], 2008 => [2, 3] }).should == tree
      end

    end # years and months

  end # archive_tree

end # ArchiveTree
