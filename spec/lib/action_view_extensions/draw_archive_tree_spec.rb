require 'spec_helper'

describe ArchiveTree::ActionViewExtensions::DrawArchiveTree do

  before :each do
    @helper = ActionView::Base.new
    @helper.instance_eval("def posts_path(*args)\n '/blog/2010'\n end\n def dummy_path(*args)\n '/dummy/2010'\n end")
  end

  describe "draw_achive_tree" do

    it "should be included in ActionView::Base" do
      ActionView::Base.instance_methods.should include :draw_archive_tree
    end # included

    describe "when there are no posts" do
      it "returns an empty string when the archive tree is empty" do
        @helper.draw_archive_tree.should be_empty
      end
    end # with no posts

    describe "with posts" do
      it "should return the archive tree for all records" do
        Factory.create :post, :created_at => Date.new(Time.now.year, 1, 1)
        Factory.create :post, :created_at => Date.new(Time.now.year, 2, 1)

        @helper.draw_archive_tree.should == %Q{<ul><li class=\"active\"><a href=\"#\" class=\"toggle\">[ + ]</a> <a href=\"/blog/2010\">2010</a><ul><li><a href=\"/blog/2010\">January (1)</a></li><li><a href=\"/blog/2010\">February (1)</a></li></ul></li></ul>}
        end
      end # with posts

      describe "overridable" do
        before :each do
          Factory.create :post, :created_at => Date.new(Time.now.year, 1, 1)
          Factory.create :post, :created_at => Date.new(Time.now.year, 2, 1)
        end

        it "allows the model name to be overriden" do
          lambda { @helper.draw_archive_tree(:hello) }.should raise_error NameError
        end

        it "allows the route to be overriden" do
          @helper.draw_archive_tree(:post, :dummy_path).should == %Q{<ul><li class=\"active\"><a href=\"#\" class=\"toggle\">[ + ]</a> <a href=\"/dummy/2010\">2010</a><ul><li><a href=\"/dummy/2010\">January (1)</a></li><li><a href=\"/dummy/2010\">February (1)</a></li></ul></li></ul>}
        end

        it "allows the toggle to be overriden" do
          html = @helper.draw_archive_tree(:post, :created_at, false)
          html.should_not include '<a href="#" class="toggle">[ + ]</a>'
        end

        it "allows the toggle text to be overriden" do
          html = @helper.draw_archive_tree(:post, :created_at, true, '+toggle+')
          html.should include '<a href="#" class="toggle">+toggle+</a>'
        end
      end # overridable

      describe "overridable route" do
        it "defaults to the hardcoded route whenever the provided route is unknown" do
          1.upto(10) { |i| Factory.create :post }

          @helper.draw_archive_tree(:post, :xpto_path).should match(/ul/)
        end
      end # overridable route

  end # draw_achive_tree

end # ArchiveTree::ActionViewExtensions::DrawArchiveTree
