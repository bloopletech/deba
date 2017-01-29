class Deba::Heading
  attr_reader :text, :level

  def initialize(text, level)
    @text = text
    @level = level
  end
end