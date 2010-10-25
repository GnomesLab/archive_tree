require 'spec_helper'

describe ArchiveTree do

  describe "archived months" do

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

  end # archived_months

end # ArchiveTree
