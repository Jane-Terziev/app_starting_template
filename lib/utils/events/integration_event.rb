class IntegrationEvent < RailsEventStore::Event
  def current_user_id
    metadata[:user_id]
  end

  def registered_at
    metadata[:registered_at]
  end

  def ==(other)
    data == other.data && self.class == other.class
  end

  alias eql? ==

  def hash
    data.hash
  end
end
