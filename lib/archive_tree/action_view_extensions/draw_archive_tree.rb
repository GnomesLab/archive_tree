module ArchiveTree
  module ActionViewExtensions

    # Defines the helper methods that will be included in the ActionView::Base in order to return the html representation of the archive tree
    module DrawArchiveTree

      # In the presence of records for a given model it draws the archive tree. Otherwise, returns an empty string
      #
      # This method relies on the following private methods:
      #   * +draw_years+
      #   * +draw_months+
      #
      # Default behavior
      #   * It will attempt to create a tree of your Post model
      #   * Will use the post_published_at_path route
      #   * Will display a toggle link
      #   * Will use "[ + ]" as the link text
      #
      # Example using the default settings:
      #   <%= draw_archive_tree %>
      #
      # Overriding the defaults example:
      #   <%= draw_archive_tree :archive, :archive_published_at_path %>

      def draw_archive_tree(model_sym = :post, route = :posts_path, toggle = true, toggle_text = '[ + ]')
        model = model_sym.to_s.capitalize.constantize

        raw model.count > 0 ? draw_years(model_sym, route, toggle, toggle_text) : ""
      end # draw_archive_tree

      private
        def draw_years(model_sym, route, toggle, toggle_text) # :nodoc:
          model = model_sym.to_s.capitalize.constantize
          route = :posts_path unless self.respond_to? route

          content_tag :ul do
            ul_body = ""

            model.archived_years.each_key do |year, count|
              ul_body << content_tag(:li, :class => year == Time.now.year ? 'active' : 'inactive') do
                (toggle ? link_to(toggle_text, "#", :class => "toggle") : '') + " " +
                  link_to(year, self.send(route, year)) +
                  draw_months(model_sym, route, year)
              end
            end

            ul_body
          end
        end

        def draw_months(model_sym, route, year) # :nodoc:
          model = model_sym.to_s.capitalize.constantize

          content_tag :ul do
            ul_body = ""

            model.archived_months(:year => year).each_pair do |month, count|
              ul_body << content_tag(:li, link_to("#{Date::MONTHNAMES[month]} (#{count})",
                                                  self.send(route, year, month < 10 ? "0#{month}" : month)))
            end

            ul_body
          end
        end
    end # DrawArchiveTree

  end # ActionViewExtensions
end # ArchiveTree
