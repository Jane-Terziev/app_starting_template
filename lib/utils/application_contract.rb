class ApplicationContract < Dry::Validation::Contract
  config.messages.backend = :i18n

  include ActiveModel::Model

  def call(input, context = {})
    result = super
    set_errors(result.errors(full: true).to_hash) if result.failure?
    set_params(input)

    result
  end

  def params
    @params ||= {}
  end

  def set_params(params)
    @params = params.with_indifferent_access
  end

  def errors
    @errors ||= {}
  end

  def set_errors(errors)
    @errors = errors.with_indifferent_access
  end
end
