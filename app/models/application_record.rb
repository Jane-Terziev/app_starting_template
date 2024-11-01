class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.save(record)
    record.save
  end

  def self.save!(record)
    record.tap(&:save!)
  end

  def delete(record)
    record.destroy
  end

  def self.delete!(record)
    record.tap(&:destroy!)
  end
end
