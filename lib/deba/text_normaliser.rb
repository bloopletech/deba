class Deba::TextNormaliser
  def initialize(text)
    @text = text
  end

  def normalise
    @text.gsub(/[\f\n\r\t\v ]+/, ' ').gsub(/\A[\f\n\r\t\v ]+/, '').gsub(/[\f\n\r\t\v ]+\Z/, '')
  end
end