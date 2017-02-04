class Deba::DefinitionDescription
  def initialize(segments, last)
    @segments = segments
    @last = last
  end

  def to_a
    @segments + ["\n#{"\n" if @last}"]
  end
end