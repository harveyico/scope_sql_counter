require 'spec_helper'
require 'support/test_models'

describe ScopeSqlCounter::Syntax do
  let!(:sql) do
    ScopeSqlCounter::Syntax.new(context: UserTest, association_key: :blogs)
  end

  describe '#call' do
    context 'when model has no selected_values' do
      it 'returns all current table attributes and add the SQL counter' do
        expect(sql.call).to eq('users.*, ( SELECT COUNT(`blogs`.id) FROM `blogs` WHERE `blogs`.`user_id` = `users`.id ) AS blogs_count')
      end
    end

    context 'when model has select_values' do
      before do
        allow(UserTest).to receive(:select_values).and_return('users.*')
      end

      it 'only returns the SQL counter' do
        expect(sql.call).to eq('( SELECT COUNT(`blogs`.id) FROM `blogs` WHERE `blogs`.`user_id` = `users`.id ) AS blogs_count')
      end
    end
  end
end
