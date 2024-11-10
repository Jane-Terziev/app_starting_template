module Injector
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def inject_dependencies(dependencies = {})
      @default_dependencies ||= {}
      @default_dependencies.merge!(dependencies)

      dependencies.each do |key, value|
        resolved_value = value.is_a?(Proc) ? value.call : value
        define_method(key) { instance_variable_get("@#{key}") || instance_variable_set("@#{key}", resolved_value) }
      end
    end

    def default_dependencies
      @default_dependencies || {}
    end
  end

  def initialize(**args)
    # Merge passed dependencies with defaults (overriding defaults with passed values)
    merged_dependencies = self.class.default_dependencies.merge(**args)
    merged_dependencies.each do |key, value|
      resolved_value = value.is_a?(Proc) ? value.call : value
      instance_variable_set("@#{key}", resolved_value)
    end
  end
end
