class ValidationError
  attr_accessor :params, :errors

  def initialize(params: {}, errors: {})
    self.params = params.with_indifferent_access
    self.errors = errors.with_indifferent_access
  end
end
