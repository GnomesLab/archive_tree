require 'spec_helper'

describe ArchiveTree do
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
end # ArchiveTree
