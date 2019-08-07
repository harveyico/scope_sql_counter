module ScopeSqlCounter
  module Orm
    module ActiveRecord
      def scope_sql_counter(scope_name, association_key)
        scope scope_name, -> {
          select(ScopeSqlCounter::Syntax.new(self, association_key))
        }
      end
    end
  end
end
