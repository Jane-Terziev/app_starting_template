class ApplicationError < StandardError
  attr_accessor :message, :error, :status

  def initialize(message:, status: 422)
    self.message = message
    self.status = status
  end
end
