require 'rails_ext'

module ArchiveTree

  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  module ClassMethods

    def years_hash
      Post.group('YEAR(created_at)').size
    end # years_hash

    def months_hash(options = {})
      _months = Post.where("YEAR(created_at) = #{options[:year] || Time.now.year}").group('MONTH(created_at)').size
      months = {}

      if type = options.delete(:month_names)
        _months.each do |month, count|
          months[ type == :long ? Date::MONTHNAMES[month.to_i] : Date::ABBR_MONTHNAMES[month.to_i] ] = count
        end
      else
        months = _months
      end

      months
    end #months_hash

  end # ClassMethods

end # ArchiveTree
