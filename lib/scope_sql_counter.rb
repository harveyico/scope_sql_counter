require 'scope_sql_counter/syntax'

unless defined?(ActiveRecord)
  class ActiveRecordDoesNotExist < StandardError; end

  raise ActiveRecordDoesNotExist.new('Sorry, this gem only supports active record for now.')
end

module ScopeSqlCounter
end
