module ScopeSqlCounter
  module Orm
    module ActiveRecord
      def scope_sql_counter(scope_name, association_key, conditions: nil, count_alias: nil)
        scope scope_name, -> {
          syntax = ScopeSqlCounter::Syntax.new(
            context: self,
            association_key: association_key,
            conditions: conditions,
            count_alias: count_alias
          )

          select(syntax.call)
        }
      end
    end
  end
end
