class TransactionError < StandardError
  attr_reader :result

  def initialize(result:)
    @result = result
    super("Transaction failed with result: #{result}")
  end
end
