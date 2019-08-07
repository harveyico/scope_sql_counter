# Scope SQL Counter
An ActiveRecord extension that helps you count association using SQL.

Since the association counting was computed within a single query, it's at least better
than doing n+1 queries. The main idea is that you don't need to use counter cache library
that migrate new columns, and use 3rd party app which is pretty annoying.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'scope_sql_counter'
```

## Usage
Unfortunately, this gem heavily relies on ActiveRecord. Well, since most
rails app use it, you are probably safe? Also, please make sure that all your
associations have indices in order to maximize the speed of your query.

### Add the scopes
So let's say your User model have a `has_many :blogs` association.
Use the ActiveRecord extension method to generate the scope:
```ruby
class User < ActiveRecord::Base
  has_many :blogs, dependent: :destroy

                    # scope name      # association name
  scope_sql_counter :with_blog_count, :blogs
end
```

This will create a scope `User.with_blog_count` on your model. And if you call it:
```ruby
irb: User.with_blog_count
=> User Load (0.8ms)
   SELECT  users.*, ( SELECT COUNT(blogs.id) FROM blogs WHERE blogs.user_id = users.id ) AS blogs_count
     FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
```

As you can see, when the query executes, it sets an alias `AS blogs_count`.
This alias should be available as a readonly attribute on your
ActiveRecord model instance. For example:

```ruby
users = User.with_blog_count
user = users.first

user.blogs_count # => 8
```

## Multiple scopes
There are times you may want to fetch multiple counter on your associations.
You can achieve this by doing:
```ruby
class User < ActiveRecord::Base
  has_many :blogs
  has_many :comments

  scope :with_multiple_count, -> {
    select(ScopeSqlCounter.new(context: self, association_key: :blogs).call)
      .select(ScopeSqlCounter.new(context: self, association_key: :comments).call)
  }
end

# But.. it doesn't look good? Then do it like this:

class User < ActiveRecord::Base
 scope_sql_counter :with_blog_count, :blogs
 scope_sql_counter :with_comment_count, :comments

 scope :with_multiple_count, -> { with_blog_count.with_comment_count }
end
```

### Additional configurations
`count_alias`: Sets the alias name for the counter instead of the default

`conditions`: Adds more condition on your scope counter instead of plain association call

1. `count_alias` . For example:
```ruby
scope_sql_counter :with_blog_count, :blogs, count_alias: :posts_count
```
```ruby
irb: users = User.with_blog_count
=> User Load (0.8ms)
   SELECT  users.*, ( SELECT COUNT(blogs.id) FROM blogs WHERE blogs.user_id = users.id ) AS posts_count
     FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]

irb: users.first.posts_count # => 0
```

2. `conditions` . For example:
```ruby
scope_sql_counter :with_published_blog_count, :blogs,
                  conditions: 'blogs.published_at IS NOT NULL',
                  count_alias: :published_blog_count
```
```ruby
irb: users = User.with_blog_count
=> User Load (0.8ms)
   SELECT  users.*, ( SELECT COUNT(blogs.id) FROM blogs WHERE blogs.user_id = users.id
                        AND blogs.published_at IS NOT NULL) AS published_blog_count
     FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]

irb: users.first.published_blog_count # => 0
```

## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add unit test
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request


## MIT
**scope_sql_counter** © 2019+, Harvey Ico. Released under the [MIT](http://mit-license.org/) License.