class NameValuePair
  attr_accessor :value, :name, :count

  def initialize(name, value)
    @name = name
    @value = value
  end
end