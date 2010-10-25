module ArchiveTree

  module Core
    def archive_node(year = Time.now.year, month = Time.now.month)
      where("YEAR(#{@date_field}) = #{year}").where("MONTH(#{@date_field}) = #{month}").order("#{@date_field} ASC")
    end

    # Constructs a single-level years hash based on your +Model#created_at+ column.
    #
    # The returned hash is a key-value-pair of integers. The key represents the year (in integer) and the value
    # represents the number of records for that year (also in integer).
    #
    # This method executes a SQL query of type COUNT, grouping the results by year.
    #
    # Note: the query makes use of the YEAR sql command, which might not be supported by all RDBMs.
    #
    # Exampe:
    #   Post.years_hash #=> { 2009 => 8, 2010 => 30 }
    def archived_years
      years = {}
      group("YEAR(#{@date_field})").size.each { |year, count| years[year.to_i] = count }

      years
    end # archived_years

    # For a given year, constructs a single-level months hash based on your +Model#created_at+ column.
    #
    # The returned hash is a key-value-pair representing the number of records for a given month, within a given years.
    # This hash can have string or integer keys, depending on the value of :month_names option,
    # which can be passed in the options hash.
    #
    # Default behaviors
    #   * By default the months are returned in their integer representation (eg.: 1 represents January)
    #   * The current year is assumed to be the default scope of the query
    #
    # Options
    #   * :year #=> Integer representing the year to sweep. Defaults to the current year.
    #   * :month_names #=> Null, or absent will result in months represented as integer (default). Also accepts :long
    # and :short, depending on the desired lenght length for the month name.
    #
    # *Considerations*
    # Given the way the queries are currently constructed and executed this method suffers from poor performance.
    #
    # TODO: Optimize the queries.
    def archived_months(options = {})
      months  = {}
      month_format = options.delete(:month_names) || :int

      where("YEAR(#{@date_field}) = #{options[:year] || Time.now.year}").group("MONTH(#{@date_field})").size.each do |month, c|
        key = case month_format
        when :long
          Date::MONTHNAMES[month.to_i]
        when :short
          Date::ABBR_MONTHNAMES[month.to_i]
        else
          month.to_i
        end

        months[key] = c
      end

      months
    end #archived_months

    # Constructs an archive tree in the form of a nested Hash.
    #
    # Hash levels
    #   1. Years  (integer)
    #   2. Months (integer)
    #   3. Your records (ActiveRecord::Relation)
    #
    # Default behaviors to take note:
    #   * All records are sweeped by default based on their +created_at+ column
    #   * Years without records are not returned
    #   * Months without records are not returned
    #   * The keys are integers, thus they will likely require conversion
    #
    # Options
    #   * :years => Array of years to sweep
    #   * :months => Array of months to sweep of each year
    #   * :years_and_months => Hash of years, each containing an Array of months to sweep
    #   * :month_names => Accepts one of two symbols :long and :short. Please note that this overrides the default value
    #
    # Examples context
    #   Please note that for the sake of simplicity these examples assume that any given year has only one +Post+
    #   record for any given month and will be represented in the following format:
    #     { 2010 => {1 => [post]} }
    #
    # Default usage:
    #   Post.archive_tree #=> { 2010 => { 1 => [Post], 2 => [Post] },
    #                           2011 => { 1 => [Post], 4 => [Post], 8 => [Post] } }
    #
    # Sweep all months of the current year:
    #   Post.archive_tree(:years => [Time.now.year]) #=> { 2010 => { 1 => [Post], 2 => [Post] } }
    #
    # Skip all months other than January (1):
    #   Post.archive_tree(:months => [1]) #=> { 2010 => { 1 => [Post] },
    #                                         { 2011 => { 1 => [Post] } } }
    #
    # Only sweep January 2010:
    #   Post.archive_tree(:years_and_months => { 2010 => [1] }) #=> { 2010 => { 1 => [Post] } }
    #
    # *Considerations*
    # This method has poor performance do the 'linear' way in whic the queries are being constructed and executed.
    #
    # TODO: Optimize the queries.
    def archive_tree(options = {})
      tree = {}
      years = options[:years_and_months] ? options[:years_and_months].keys : nil || options[:years] ||
        archived_years.keys || []

      years.each do |year|
        tree[year] = {}
        months = archived_months(:year => year).keys

        if options[:years_and_months]
          months.reject! { |m| options[:years_and_months][year].include?(m) == false }
        elsif options[:months]
          months.reject! { |m| options[:months].include?(m) == false }
        end

        months.each do |month|
          tree[year][month] = {}
          tree[year][month] = archive_node year, month
        end
      end

      tree
    end # archive_tree

  end # Core

end # ArchiveTree