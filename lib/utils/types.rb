module Types
  include Dry.Types()

  StrippedString = Types::String.constructor(&:strip)
  DateTime = Types::DateTime.constructor(&:to_datetime)
  Date = Types::Date.constructor(&:to_date)
end
