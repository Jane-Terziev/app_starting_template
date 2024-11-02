class MetadataEventPublisher
  attr_reader :client, :current_user_repository

  def initialize(client:, current_user_repository: CurrentUserRepository)
    self.client = client
    self.current_user_repository = current_user_repository
  end

  def publish(event)
    user_id = current_user_repository&.authenticated_identity&.id
    client.with_metadata({ user_id: user_id, registered_at: DateTime.now }) { client.publish(event) }
  end

  def publish_all(events)
    events.each { |event| publish(event) }
    events.clear
  end

  def subscribe(subscriber, to:)
    client.subscribe(subscriber, to: to)
  end

  def mapper
    client.send(:mapper)
  end

  def deserialize(serialized_event, serializer)
    serializer.load(serialized_event)
  end

  private

  attr_writer :client, :current_user_repository
end
