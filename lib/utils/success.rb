class Success
  attr_reader :result

  def initialize(result: {})
    self.result = result
  end

  def and_then(&block)
    block.call(self.result)
  end

  def success?
    true
  end

  def failure?
    false
  end

  private

  attr_writer :result
end
