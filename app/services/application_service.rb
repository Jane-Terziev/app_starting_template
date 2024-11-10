class ApplicationService
  def self.call(inject: {}, **args)
    service = new(**inject)
    service.call(**args)

  rescue TransactionError => e
    service.log_error(e) if e.result.error.is_a?(InternalError)
    e.result
  end

  def initialize(
    current_user_repository: CurrentUserRepository,
    error_logger: NewRelic::Agent
  )
    self.current_user_repository = current_user_repository
    self.error_logger = error_logger
  end

  def call(*args)
    raise NotImplementedError, "Subclasses must implement a 'call' method"
  end

  def log_error(exception)
    message = <<~Message
      #{self.class.name} failed.
      Error Type: #{exception.result.error.class}
      Message: #{exception.result.error}.
      Details: #{exception.result.error.details}
    Message

    NewRelic::Agent.notice_error(message, custom_params: { details: exception.result.error.details })
  end

  private

  def contract
    raise StandardError.new("undefined method contract")
  end

  def validate_params(params)
    contract.new.call(params)
            .tap { return Failure.new(error: ValidationError.new(params: _1.to_h, errors: _1.errors.to_h)) if _1.failure? }
            .tap { @sanitized_params = _1.to_h }
    Success.new
  end

  def publish_all(aggregate_root)
    Success.new
  end

  attr_writer :current_user_repository, :error_logger
end
