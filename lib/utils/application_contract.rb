class ApplicationContract < Dry::Validation::Contract
  config.messages.backend = :i18n

  include ActiveModel::Model

  def call(input, context = {})
    result = super
    @errors = result.errors(full: true).to_hash.with_indifferent_access if result.failure?
    @params = input.with_indifferent_access

    result
  end

  def params
    @params ||= {}
  end

  def errors
    @errors ||= {}
  end
end
