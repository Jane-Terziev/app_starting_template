class ValidationError
  attr_accessor :validator

  def initialize(validator:)
    self.validator = validator
  end
end
