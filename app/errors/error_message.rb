class ErrorMessage
  attr_accessor :message

  def initialize(message:)
    self.message = message
  end

  def to_s
    self.message
  end
end
