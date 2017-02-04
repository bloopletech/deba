class Deba::DefinitionTerm
  def initialize(segments)
    @segments = segments
  end

  def to_a
    @segments + [":\n"]
  end
end