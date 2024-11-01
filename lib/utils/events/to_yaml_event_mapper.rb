require "ruby_event_store/mappers/pipeline_mapper"

class ToYAMLEventMapper < RubyEventStore::Mappers::PipelineMapper
  attr_reader :pipeline

  def initialize(pipeline: YAML)
    self.pipeline = pipeline
  end

  private

  attr_writer :pipeline
end
