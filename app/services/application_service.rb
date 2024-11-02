class ApplicationService
  attr_reader :event_publisher

  def initialize(event_publisher: Rails.configuration.event_publisher)
    self.event_publisher = event_publisher
  end

  private

  def contract
    raise StandardError.new("undefined method contract")
  end

  def validate_params(params)
    result = contract.new.call(params)

    return Failure.new(error: ValidationError.new(params: result.to_h, errors: result.errors.to_h)) if result.failure?

    @sanitized_params = result.to_h
    Success.new
  end

  def publish_all(aggregate_root)
    event_publisher.publish_all(aggregate_root.domain_events)
    Success.new
  end

  attr_writer :event_publisher
end
