class ApplicationService
  attr_reader :event_publisher

  def self.call(inject: {}, **args)
    new(**inject).call(**args)

  rescue TransactionError => e
    log_error(e.result) if e.result.is_a?(InternalError)
    e.result
  end

  def self.log_error(result)
    # TODO: Implement logging, stack trace, etc.
  end

  def initialize(current_user_repository: CurrentUserRepository, event_publisher: Rails.configuration.event_publisher)
    self.current_user_repository = current_user_repository
    self.event_publisher = event_publisher
  end

  def call(*args)
    raise NotImplementedError, "Subclasses must implement a 'call' method"
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
    event_publisher.publish_all(aggregate_root.domain_events)
    Success.new
  end

  attr_writer :event_publisher, :current_user_repository
end
