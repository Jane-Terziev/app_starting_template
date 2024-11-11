class Failure
  attr_reader :message, :error_class, :status

  def initialize(message:, error_class: nil, status: 422)
    self.message = message
    self.error_class = error_class
    self.status = status
  end

  def and_then(&_block)
    self
  end

  def success?
    false
  end

  def failure?
    true
  end

  def to_s
    self.message
  end

  private

  attr_writer :message, :error_class, :status
end
