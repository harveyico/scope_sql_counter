# frozen_string_literal: true

module ScopeSqlCounter
  class Syntax
    COUNTER_SQL_QUERY = <<-SQL
      (
        SELECT COUNT(:target.id)
        FROM :target
        WHERE :target.:foreign_key = :context.id
      ) AS :alias
    SQL

    attr_reader :context, :association

    def initialize(context:, association_key:)
      @context = context
      @association = context.reflect_on_association(association_key)
    end

    def call
      query = COUNTER_SQL_QUERY.gsub(':target', association.table_name)
                               .gsub(':foreign_key', association.foreign_key)
                               .gsub(':context', context.table_name)
                               .gsub(':alias', "#{association.table_name}_count")
                               .squish

      if !context.respond_to?(:select_values) || context.select_values.blank?
        ["#{context.table_name}.*", query].join(', ')
      else
        query
      end
    end
  end
end
