require 'sinatra/base'
require 'json'
require_relative 'ledger'

module ExpenseTracker
  class API < Sinatra::Base
    def initialize(ledger = Ledger.new)
      @ledger = ledger
      super()
    end

    post '/expenses' do
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)

      if result.success?
        status 200 
        JSON.generate({'expense_id' => result.expense_id})
      else
        status 422
        JSON.generate({'error' => result.errors})
      end
    end

    get '/expenses/:date' do
      status 200
      JSON.generate(@ledger.expenses_on(params[:date]))
    end
  end
end
