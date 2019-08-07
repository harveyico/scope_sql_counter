# frozen_string_literal: true

module ScopeSqlCounter
  class Syntax
    COUNTER_SQL_QUERY = <<-SQL
      (
        SELECT COUNT(:target.id)
        FROM :target
        WHERE :target.:foreign_key = :context.id
        :conditions
      ) AS :alias
    SQL

    attr_reader :context, :association, :conditions, :count_alias

    def initialize(context:, association_key:, conditions: nil, count_alias: nil)
      @context = context
      @association = context.reflect_on_association(association_key)
      @conditions = conditions
      @count_alias = count_alias
    end

    def call
      if !context.respond_to?(:select_values) || context.select_values.blank?
        ["#{context.table_name}.*", query].join(', ')
      else
        query
      end
    end

    private

    def query
      COUNTER_SQL_QUERY.gsub(':target', association.table_name)
                       .gsub(':foreign_key', association.foreign_key)
                       .gsub(':context', context.table_name)
                       .gsub(':conditions', conditions_sql)
                       .gsub(':alias', count_alias_sql)
                       .squish
    end

    def count_alias_sql
      count_alias.to_s.presence || "#{association.table_name}_count"
    end

    def conditions_sql
      String.new.tap do |str|
        if conditions.present?
          str << "AND #{conditions}"
        end
      end
    end
  end
end
