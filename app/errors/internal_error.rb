class InternalError
  attr_accessor :message, :details

  def initialize(message:, details: {})
    self.message = message
    self.details = details
  end
end
