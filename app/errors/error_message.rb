class ErrorMessage < StandardError
  attr_accessor :message

  def initialize(message:)
    self.message = message
  end
end
