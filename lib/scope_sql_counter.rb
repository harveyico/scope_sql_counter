require 'scope_sql_counter/syntax'
require 'scope_sql_counter/orm/active_record'

unless defined?(ActiveRecord)
  class ActiveRecordDoesNotExist < StandardError; end

  raise ActiveRecordDoesNotExist.new('Sorry, this gem only supports active record right now.')
end

module ScopeSqlCounter
end

ActiveRecord::Base.extend(ScopeSqlCounter::Orm::ActiveRecord)
