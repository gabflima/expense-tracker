require_relative '../../../app/api'
require 'rack/test'


module ExpenseTracker
  # create simple model
  RecordResult = Struct.new(:success?, :expense_id, :errors)

  RSpec.describe API do
    include Rack::Test::Methods

    # declare a double, which will mimic every call to the class in argument
    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    def app
      API.new(ledger)
    end

    def json_response
      JSON.parse(last_response.body)
    end

    describe 'POST /expenses' do
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
            .and_return(RecordResult.new(false, nil, ["Expense incomplete"]))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)
          expect(json_response).to include('error' => ['Expense incomplete'])
        end

        it 'responds with a 422 (Unprocessable entity)' do 
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /expenses/:date' do
      let(:date) { "2017-06-12" }

      context 'when expenses exist on the given date' do
        let (:expense) { { 'some' => 'data' } }

        before do
          allow(ledger).to receive(:expenses_on)
            .with(date)
            .and_return([expense])
        end

        it 'returns the expense records as JSON' do
          get "/expenses/#{date}"
          expect(json_response).to include(expense)
        end

        it 'responds with a 200 (OK)' do
          get "/expenses/#{date}"
          expect(last_response.status).to eq(200)
        end
      end

      context 'when there are no expenses on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with(date)
            .and_return([])
        end

        it 'returns an empty array as JSON' do
          get "/expenses/#{date}"
          expect(json_response).to eq([])
        end

        it 'responds with a 200 (OK)' do
          get "/expenses/#{date}"
          expect(last_response.status).to eq(200)
        end
      end
    end

  end
end
