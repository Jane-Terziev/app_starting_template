class InternalError
  attr_accessor :message, :details

  def initialize(message:, details: {})
    self.message = message
    self.details = details
  end

  def to_s
    "#{self.class.name}: #{self.message}"
  end
end
