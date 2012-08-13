class NameValuePair
  attr_accessor :value, :name

  def initialize(name, value)
    @name = name
    @value = value
  end
end