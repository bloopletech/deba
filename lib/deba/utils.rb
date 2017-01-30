class Deba::Utils
  BLANK_RE = /\A[[:space:]]*\z/

  def self.blank?(text)
    text.empty? || text =~ BLANK_RE
  end

  def self.present?(text)
    !blank?(text)
  end

  def self.normalise(text)
    text.gsub(/[[:space:]]+/, ' ').strip
  end
end