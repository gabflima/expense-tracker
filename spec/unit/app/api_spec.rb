require_relative '../../../app/api'
require 'rack/test'


module ExpenseTracker
  
  # create simple model
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  RSpec.describe API do
    include Rack::Test::Methods

    # declare a double, which will mimic every call to the class in argument
    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    def app
      API.new(Ledger.new)
    end

    describe 'POST /expenses' do
      def json_response
        JSON.parse(last_response.body)
      end

      context 'when the expense is sucessfully recorded' do
        let(:expense) { 
          { 'some' => 'data' }
        }

        before do
          # declare a mapping of function call and argument to response in double
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)
          expect(json_response).to include('expense_id' => 417)
        end

        it 'responds with a 200 (ok)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        let(:expense) { 
          { 'some' => 'wrong data' }
        }

        before do
          # declare a mapping of function call and argument to response in double
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, -1, "Expense incomplete"))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)
          expect(json_response).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do 
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /expenses/:date' do
      context 'when expenses exist on the given date' do
        it 'returns the expense records as JSON'
        it 'responds with a 200 (OK)'
      end

      context 'when there are no expenses on the given date' do
        it 'returns an empty array as JSON'
        it 'responds with a 200 (OK)'
      end
    end

  end
end
