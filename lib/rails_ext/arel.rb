require 'arel' unless defined? Arel

module Arel

  module SqlCompiler

    class GenericCompiler

      def select_sql
        projections = @relation.projections
        @engine = engine

        if Count === projections.first && projections.size == 1 &&
            (relation.taken.present? || relation.wheres.present?) && relation.joins(self).blank?
          subquery = [
            "SELECT 1 FROM #{relation.send(:from_clauses)}", build_clauses
          ].join ' '
          query = "SELECT COUNT(*) AS count_id FROM (#{subquery}) AS subquery"
        else
          query = [
            "SELECT     #{relation.send(:select_clauses).join(', ')}",
            "FROM       #{relation.send(:from_clauses)}",
            build_clauses
          ].compact.join ' '
        end
        query
      end # select_sql

      def build_clauses
        joins   = relation.joins(self)
        wheres  = relation.send(:where_clauses)
        groups  = relation.send(:group_clauses)
        havings = relation.send(:having_clauses)
        orders  = relation.send(:order_clauses)

        clauses = [ "",
                    joins,
                    ("WHERE     #{wheres.join(' AND ')}" unless wheres.empty?),
                    ("GROUP BY  #{groups.join(', ')}" unless groups.empty?),
                    ("HAVING    #{havings.join(' AND ')}" unless havings.empty?),
                    ("ORDER BY  #{orders.join(', ')}" unless orders.empty?)
                    ].compact.join ' '

        offset = relation.skipped
        limit = relation.taken
        @engine.connection.add_limit_offset!(clauses, :limit => limit,
                                             :offset => offset) if offset || limit

        clauses << " #{locked}" unless locked.blank?
        clauses unless clauses.blank?
      end # build_clauses

    end # GenericCompiler

  end # SqlCompiler

end # Arel
