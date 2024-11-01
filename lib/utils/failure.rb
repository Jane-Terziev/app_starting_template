class Failure
  attr_reader :error, :status

  def initialize(error:, status: 422)
    self.error = error
    self.status = status
  end

  def and_then(&block)
    self
  end

  def success?
    false
  end

  def failure?
    true
  end

  private

  attr_writer :error, :status
end
