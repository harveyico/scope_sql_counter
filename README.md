# Scope SQL Counter
An ActiveRecord extension that helps you count association using SQL.

Since the association counting was computed within a single query, it's better
than doing n+1 queries. The main idea is that you don't need to use counter cache library
and migrate new columns which is pretty annoying.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'scope_sql_counter'
```

## Usage
Unfortunately, this gem heavily depends on ActiveRecord. Well, since most
rails app use it, so I think you're safe?

### Add the scopes
Let's say you have a User model that has_many blogs association.
Use the extension method to generate the scope:
```ruby
class User < ActiveRecord::Base
  has_many :blogs

                    # scope name      # association name
  scope_sql_counter :with_blog_count, :blogs
end
```

This will produce a scope `User.with_blog_count` on your model. And if you call it:
```ruby
irb: User.with_blog_count
=> User Load (0.8ms)
   SELECT  users.*, ( SELECT COUNT(blogs.id) FROM blogs WHERE blogs.user_id = users.id ) AS blogs_count
     FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
```

As you can see, when the query executes, it sets an alias `AS blogs_count`.
This should be available now available as a readonly attribute on your
ActiveRecord models. For example:

```ruby
users = User.with_blog_count
user = users.first

user.blogs_count # => 8
```

## Multiple scopes
There are times you may want to fetch multiple counter on your associations.
You can achieve this by doing:
```
class User < ActiveRecord::Base
  has_many :blogs
  has_many :comments

  scope :with_multiple_count, -> {
    select(ScopeSqlCounter.new(context: self, association_key: :blogs).call)
      .select(ScopeSqlCounter.new(context: self, association_key: :comments).call)
  }
end

# or do it like this:

class User < ActiveRecord::Base
 scope_sql_counter :with_blog_count, :blogs
 scope_sql_count :with_comment_count, :comments

 scope :with_multiple_count, -> { with_blog_count.with_comment_count }
end
```