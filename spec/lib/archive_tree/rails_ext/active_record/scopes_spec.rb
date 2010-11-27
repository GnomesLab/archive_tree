require 'spec_helper'

describe ArchiveTree::RailsExt::ActiveRecord::Scopes do

  describe "archive_node" do

    before :each do
      1.upto(2) { |i| Factory.create(:post, :created_at => "#{Time.now.year}-0#{i}-01 00:00:00") }
      1.upto(2) { |i| Factory.create(:post, :created_at => "#{Time.now.year + 1}-0#{i}-01 00:00:00") }
    end

    describe "defaults" do
      it "uses the current year" do
        Post.archive_node.each { |p| p.created_at.year.should == Time.now.year }
      end

      it "ignores the month" do
        Post.archive_node.should have(2).record
      end

    end # defaults

    describe "overridable" do
      it "allows to override the year" do
        year = Time.now.year + 1
        Post.archive_node(:year => year).each { |p| p.created_at.year.should == year }
      end

      it "allows to select a month" do
        Post.archive_node(:year => Time.now.year, :month => 1).each { |p| p.created_at.month.should == 1 }
      end

      it "allows to override the year and select a month" do
        Post.archive_node(:year => Time.now.year, :month => 1).should have(1).record
      end
    end # overridables

  end # archive_node

  describe "archived_years" do

    it "returns an empty hash if no years are archived" do
      Post.archived_years.should == {}
    end

    it "returns a years counter hash" do
      2.times { |i| Factory.create(:post, :created_at => "#{Time.now.year + i}-#{01 + i}-01 00:00:00") }

      Post.archived_years.should == { Time.now.year => 1, (Time.now.year + 1) => 1 }
    end

    it "discards dates that are null" do
      2.times { |i| Factory.create(:post, :created_at => "#{Time.now.year + i}-#{01 + i}-01 00:00:00") }

      Post.last.update_attributes(:created_at => nil)

      Post.archived_years.should == { Time.now.year => 1 }
    end

  end # archived_years

  describe "archived_months" do

    before :each do
      2.times do |i|
        Factory.create(:post, :created_at => "#{Time.now.year + i}-01-01 00:00:00")
        Factory.create(:post, :created_at => "#{Time.now.year + i}-02-01 00:00:00")
      end
    end

    it "returns an empty hash if no records exist for a given year" do
      Post.archived_months(:year => 3000).should == {}
    end

    it "returns an integer months counter hash" do
      Post.archived_months.should == { 1 => 1, 2 => 1 }
    end

    it "defaults it's sweep year to the current year" do
      Factory.create :post, :created_at => "#{Time.now.year}-#{12}-01 00:00:00"
      Post.archived_months == { 1 => 1, 2 => 1, 12 => 1 }
    end

    it "allows the invoker to specify the year being sweeped" do
      Post.archived_months(:year => (Time.now.year + 1)).should == { 1 => 1, 2 => 1 }
    end

    it "allows the type of month name to be specified as short" do
      Post.archived_months(:month_names => :short).should == { "Jan" => 1, "Feb" => 1 }
    end

    it "allows the type of month name to be specified as long" do
      Post.archived_months(:month_names => :long).should == { "January" => 1, "February" => 1 }
    end

    it "defaults to :month_names => :int whenever an unknown value is passed" do
      Post.archived_months(:month_names => :invalid_value).should == { 1 => 1, 2 => 1 }
    end

    it "discards dates that are null" do
      Post.first.update_attributes(:created_at => nil)
      Post.archived_months.should == { 2 => 1 }
    end
  end # archived_months

  describe "archive_tree" do

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

end # ArchiveTree::RailsExt::ActiveRecord::Scopes
