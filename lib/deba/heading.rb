class Deba::Heading
  def initialize(segments, level)
    @segments = segments
    @level = level
  end

  def to_a
    ["#" * @level] + @segments + ["\n\n"]
  end
end