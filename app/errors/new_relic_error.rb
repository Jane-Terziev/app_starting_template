class NewRelicError < StandardError
  attr_accessor :backtrace, :name

  def initialize(result:, name:)
    super("#{result.error.message} #{result.error.internal_details}")
    self.backtrace = result.error.backtrace
    self.class.name = name
  end

  def self.name
    @name
  end

  def self.name=(name)
    @name = name
  end
end
