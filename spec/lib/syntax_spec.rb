require 'spec_helper'
require 'support/test_models'

describe ScopeSqlCounter::Syntax do
  let!(:count_alias) { nil }
  let!(:conditions) { nil }
  let!(:arguments) do
    {
      context: UserTest,
      association_key: :blogs,
      count_alias: count_alias,
      conditions: conditions
    }
  end

  let!(:sql) do
    ScopeSqlCounter::Syntax.new(arguments)
  end

  describe '#call' do
    context 'when model has no selected_values' do
      it 'returns all current table attributes and add the SQL counter' do
        expect(sql.call).to eq('users.*, ( SELECT COUNT(blogs.id) FROM blogs WHERE blogs.user_id = users.id ) AS blogs_count')
      end
    end

    context 'when model has select_values' do
      before do
        allow(UserTest).to receive(:select_values).and_return('users.*')
      end

      it 'only returns the SQL counter' do
        expect(sql.call).to eq('( SELECT COUNT(blogs.id) FROM blogs WHERE blogs.user_id = users.id ) AS blogs_count')
      end
    end

    context 'if count_alias is passed' do
      let!(:count_alias) { 'random_count' }

      it 'sets the alias based on the text' do
        expect(sql.call).to eq('users.*, ( SELECT COUNT(blogs.id) FROM blogs WHERE blogs.user_id = users.id ) AS random_count')
      end
    end

    context 'if conditions is passed' do
      let!(:conditions) { 'blogs.created_at IS NULL' }

      it 'adds the condition on your scope counter' do
        expect(sql.call).to eq('users.*, ( SELECT COUNT(blogs.id) FROM blogs WHERE blogs.user_id = users.id AND blogs.created_at IS NULL ) AS blogs_count')
      end
    end
  end
end
