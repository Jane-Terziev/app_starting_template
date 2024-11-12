class InternalError < ApplicationError
  attr_reader :internal_details, :backtrace

  def initialize(message:, internal_details:, status: 422)
    super(message: message, status: status)
    self.internal_details = internal_details
    self.backtrace = caller
  end

  private

  attr_writer :internal_details, :backtrace
end
