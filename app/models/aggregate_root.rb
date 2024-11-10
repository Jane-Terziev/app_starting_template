class AggregateRoot < ApplicationRecord
  self.abstract_class = true

  def domain_events
    @domain_events ||= []
  end

  def apply_event(event_name:, payload: {})
    domain_events << { event_name: event_name, payload: payload }
    self.updated_at = DateTime.now
  end

  attr_writer :domain_events
end
