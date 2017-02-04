class Deba::Paragraph
  def initialize(segments)
    @segments = segments
  end

  def always?
    false
  end

  def to_a
    @segments + ["\n\n"]
  end
end