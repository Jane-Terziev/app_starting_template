module ApplicationValidator
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Model
    include ActiveModel::Validations

    class_attribute :defined_attributes, default: {}
  end

  class_methods do
    def attribute(attr_name, attr_type, required: false)
      # Define the attribute accessor
      attr_accessor attr_name

      # Store attribute definition
      self.defined_attributes = defined_attributes.merge(
        attr_name => { type: attr_type, required: required }
      )

      # Add validation methods based on the type and required option
      validate do
        validate_presence(attr_name) if required
        validate_type(attr_name, attr_type)
      end
    end
  end

  ATTRIBUTE_MAPPINGS = {
    string: String,
    integer: Integer,
    float: Float,
    boolean: [ TrueClass, FalseClass ],
    date: Date,
    datetime: DateTime
  }.freeze

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  private

  def validate_type(attr_name, attr_type)
    value = send(attr_name)
    return if value.nil? && !self.class.defined_attributes[attr_name][:required]

    expected_class = ATTRIBUTE_MAPPINGS[attr_type.to_sym]

    unless Array(expected_class).any? { |klass| value.is_a?(klass) }
      errors.add(attr_name, "must be of type #{attr_type}")
    end
  end

  def validate_presence(attr_name)
    value = send(attr_name)
    errors.add(attr_name, "can't be blank") if value.nil? || (value.is_a?(String) && value.strip.empty?)
  end
end


