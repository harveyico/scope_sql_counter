class BlogTest
  class << self
    def table_name
      'blogs'
    end

    def foreign_key
      'user_id'
    end

    def macro
      :has_many
    end

    def through_reflection
    end
  end
end

class UserTest
  class << self
    def table_name
      'users'
    end

    def reflect_on_association(key)
      "#{key.to_s.singularize.capitalize}Test".constantize
    end

    def select_values
      []
    end
  end
end
