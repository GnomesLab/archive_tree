require 'spec_helper'

describe ArchiveTree do

  describe "archived years" do

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

end # ArchiveTree
