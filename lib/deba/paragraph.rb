class Deba::Paragraph
  def initialize(segments)
    @segments = segments
  end

  def to_a
    @segments + ["\n\n"]
  end
end