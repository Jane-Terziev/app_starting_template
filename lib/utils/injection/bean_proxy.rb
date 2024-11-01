class BeanProxy
  def initialize(bean_name:)
    self.bean_name = bean_name
  end

  def bean
    App::Container.resolve(bean_name)
  end

  delegate_missing_to :bean

  private

  attr_accessor :bean_name
end
