class Failure
  attr_reader :error

  def initialize(error:)
    self.error = error
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

  private

  attr_writer :error
end
