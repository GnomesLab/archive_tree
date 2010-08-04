require 'active_record' unless defined? ActiveRecord

module ActiveRecord

  module Calculations

    def execute_simple_calculation(operation, column_name, distinct) #:nodoc:
      column = if @klass.column_names.include?(column_name.to_s)
        Arel::Attribute.new(@klass.unscoped, column_name)
      else
        Arel::SqlLiteral.new(column_name == :all ? "*" : column_name.to_s)
      end

      # Postgresql doesn't like ORDER BY when there are no GROUP BY
      if engine.adapter_name == 'PostgreSQL'
        relation = except(:order).select(operation == 'count' ? column.count(distinct) : column.send(operation))
      else
        relation = select(operation == 'count' ? column.count(distinct) : column.send(operation))
      end

      type_cast_calculated_value(@klass.connection.select_value(relation.to_sql), column_for(column_name), operation)
    end # execute_simple_calculation

  end # Calculations

end # ActiveRecord