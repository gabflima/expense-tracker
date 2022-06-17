module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
      return RecordResult.new(false, -1, "Nothing Implemented")
    end

    def expenses_on(date)

    end
  end
  
end
