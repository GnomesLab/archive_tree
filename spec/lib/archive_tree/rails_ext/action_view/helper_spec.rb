require 'spec_helper'

describe ArchiveTree::RailsExt::ActionView::Helper do

  before :each do
    @helper = ActionView::Base.new

    # Stub some routes into ActionView::Base
    @helper.stub!(:posts_path).and_return('/blog/2009')
    @helper.stub!(:dummy_path).and_return('/dummy/2009')
  end # before each

  describe "draw_achive_tree" do

    it "should be included in ActionView::Base" do
      @helper.should respond_to :draw_archive_tree
    end # included

    describe "without posts" do
      it "returns an empty string when the archive tree is empty" do
        @helper.draw_archive_tree(:post).should be_empty
      end
    end # without posts

    describe "with posts" do
      before :each do
        Factory.create(:post, :created_at => Date.new(2009, 1, 1))
        Factory.create(:post, :created_at => Date.new(2009, 2, 1))
      end

      describe "parameters" do
        it "returns the archive tree for the posts model" do
          @html = Nokogiri::HTML(@helper.draw_archive_tree(:post))
          @html.css('body > ul > li').should have(1).element
          @html.css('ul ul li').should have(2).elements
        end

        it "returns the archive tree using the posts_path route" do
          @html = Nokogiri::HTML(@helper.draw_archive_tree(:post))
          @html.css('body > ul > li').should have(1).element
          @html.css('ul ul a[href="/blog/2009"]').should have(2).elements
        end

        it "returns the archive tree using the dummy_path route" do
          @html = Nokogiri::HTML(@helper.draw_archive_tree(:post, :dummy_path))
          @html.css('body > ul > li').should have(1).element
          @html.css('ul ul a[href="/dummy/2009"]').should have(2).elements
        end
      end # parameters

      describe "current year" do
        it "returns the current year with the 'current' class" do
          Factory.create(:post, :created_at => Time.now)
          @html = Nokogiri::HTML(@helper.draw_archive_tree(:post))
          @html.css('body > ul > .current').should have(1).element
        end
      end # current year

      describe "years list" do
        it "must have the year digits" do
          @html = Nokogiri::HTML(@helper.draw_archive_tree(:post))
          @html.css('body > ul > li > a').text.should include '2009'
        end

        it "must have the months count" do
          @html = Nokogiri::HTML(@helper.draw_archive_tree(:post))
          @html.css('body > ul > li > a').text.should include '(2)'
        end
      end # years list

      describe "months list" do
        it "must have the months names" do
          @html = Nokogiri::HTML(@helper.draw_archive_tree(:post))
          @html.css('body > ul ul a').text.should include 'January', 'February'
        end

        it "must have the months count" do
          @html = Nokogiri::HTML(@helper.draw_archive_tree(:post))
          @html.css('body > ul ul a').text.should include '(1)', '(1)'
        end
      end # years list

    end # with posts

  end # draw_achive_tree

end # ArchiveTree::ActionViewExtensions
