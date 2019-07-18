require 'rails_helper'

RSpec.describe WebNode, type: :model do
  context 'validations' do
    it 'validates presence of name' do
      record = WebNode.new
      record.valid?
      expect(record.errors.messages[:name]).to include("can't be blank")
    end
  end
end
