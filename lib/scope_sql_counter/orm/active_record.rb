module ScopeSqlCounter
  module Orm
    module ActiveRecord
      def scope_sql_counter(scope_name, association_key)
        scope scope_name, -> {
          syntax = ScopeSqlCounter::Syntax.new(context: self, association_key: association_key)
          select(syntax.call)
        }
      end
    end
  end
end
