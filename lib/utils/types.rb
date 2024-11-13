module Types
  include Dry.Types()

  Email = Types::String.constructor(&:downcase)
                       .constrained(format: /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\z/i)
  DateTime = Types::DateTime.constructor(&:to_datetime)
  Date = Types::Date.constructor(&:to_date)
  Coercible::Bool = Types::Bool.constructor { |value| ActiveRecord::Type::Boolean.new.serialize value }
end
