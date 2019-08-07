# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'scope_sql_counter/version'

Gem::Specification.new do |s|
  s.name        = 'scope_sql_counter'
  s.version     = ScopeSqlCounter::VERSION
  s.date        = '2019-08-02'
  s.summary     = 'Don\'t want to use counter cache anymore? Achieve it with plain SQL query instead!'
  s.description = <<-DESC
    A gem that provides helper to achieve association counting without hassle.
    It provides you readonly data inside your ActiveRecord model without executing n+1 queries!
  DESC
  s.authors     = ['Harvey Ico']
  s.email       = 'godstrikerharvey@gmail.com'
  s.files       = `git ls-files`.split($/)
  s.homepage    = 'https://rubygems.org/gems/scope-sql-counter'
  s.license     = 'MIT'

  s.require_paths = ['lib']

  s.add_development_dependency 'activerecord', '~> 5.2.3'
  s.add_development_dependency 'bundler', '~> 2.0.2'
  s.add_development_dependency 'rake', '~> 12.3.3'
  s.add_development_dependency 'rspec', '~> 3.8.0'
end