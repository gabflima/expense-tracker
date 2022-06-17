require 'rack/test'
require 'json'
require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end
  
    it 'records submitted expenses' do
      # Arrange
      coffee = {
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      }

      # Act
      # Rack::Test::Methods#post - simulate posts by direct call, no parsing
      post '/expenses', JSON.generate(coffee)

      # Assert
      parsed = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
    end
  end
end
