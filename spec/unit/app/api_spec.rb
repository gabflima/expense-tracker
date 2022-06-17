require_relative '../../../app/api'
require 'rack/test'


module ExpenseTracker
  
  # create simple model
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  RSpec.describe API do
    include Rack::Test::Methods

    # declare a double
    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    def app
      API.new(ledger)
    end

    describe 'POST /expenses' do
      context 'when the expense is sucessfully recorded' do
        it 'returns the expense id' do
          expense = { 'some' => 'data' }

          # declare a mapping of function call and argument to response
          # in double
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))

          post '/expenses', JSON.generate(expense)

          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('expense_id' => 417)
        end

        it 'responds with a 200 (ok)'
      end

      context 'when the expense fails validation' do
        it 'returns an error message'
        it 'responds with a 422 (Unprocessable entity)'
      end
    end
  end
end
