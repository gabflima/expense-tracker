require 'rack/test'
require 'json'
require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end
    
    def post_expense(expense)
      # Act
      # Rack::Test::Methods#post - simulate posts by direct call, no parsing
      post '/expenses', JSON.generate(expense)

      #Assert
      parsed = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => parsed['expense_id'])
    end

    it 'records submitted expenses' do
      pending 'Need to persist expenses'
      # Arrange and post_expenses
      coffee = post_expense({
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      })

      zoo = post_expense({
        'payee' => 'Zoo',
        'amount' => 15.25,
        'date' => '2017-06-10'
      })

      groceries = post_expense({
        'payee' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2017-06-11'
      })

      # Act
      get '/expenses/2017-06-10'
      
      #Assert
      expect(last_response.status).to eq(200)
      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end
  end
end
