module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
      return RecordResult.new(false, -1, "Nothing Implemented")
    end
  end
  
end
