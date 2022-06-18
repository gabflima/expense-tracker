require_relative '../config/sequel'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :errors)

  class Ledger
    def record(expense)
      errors = validate(expense)
      if errors.size > 0
        RecordResult.new(false, nil, errors)
      else
        DB[:expenses].insert(expense)
        id = DB[:expenses].max(:id)
        RecordResult.new(true, id, nil)
      end
    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all 
    end

    private def validate(expense)
      errors = []
      unless expense.key?('payee')
        errors << 'Invalid expense: `payee` is required'
      end
      return errors
    end
  end
  
end
