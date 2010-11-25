module ArchiveTree

  module ActionViewExtensions

    # In the presence of records for a given model it draws the archive tree. Otherwise, returns an empty string
    #
    # This method relies on the following private methods:
    #   * +draw_years+
    #   * +draw_months+
    #
    # Parameters
    #  * model_sym #=> model that responds to :archived_years and :archived_months
    #  * route #=> route used to generate the links
    #
    # Default behavior
    #   * Will use the index route for the given model.
    #
    # Example using the default route, e.g. for post model is posts_path
    #   <%= draw_archive_tree :post %>
    #
    # Using a specific route:
    #   <%= draw_archive_tree :post, :archive_published_at_path %>
    def draw_archive_tree(model_sym, route=nil)
      route = "#{model_sym.to_s.pluralize}_path" if route.nil?
      draw_years(model_sym.to_s.capitalize.constantize, route)
    end # draw_archive_tree

    private
      def draw_years(model, route) # :nodoc:
        archived_years = model.archived_years
        return '' if archived_years.count == 0

        content_tag :ul do
          ul_body = ''

          archived_years.each_pair do |year, count|
            ul_body << content_tag(:li, :class => year == Time.now.year ? 'current' : '') do
              link_to("#{year} (#{count})", self.send(route, year)) + draw_months(model, route, year)
            end
          end

          ul_body.html_safe
        end
      end # draw_years

      def draw_months(model, route, year) # :nodoc:
        archived_months = model.archived_months(:year => year)
        return '' if archived_months.count == 0

        content_tag :ul do
          ul_body = ''

          archived_months.each_pair do |month, count|
            ul_body << content_tag(:li, link_to("#{Date::MONTHNAMES[month]} (#{count})",
                                                self.send(route, year, "%02d" % month)))
          end

          ul_body.html_safe
        end
      end # draw_months

  end # ActionViewExtensions

end # ArchiveTree
