class Deba::DefinitionTerm
  attr_reader :segments

  def initialize(segments)
    @segments = segments
  end

  def to_s
    "#{Deba::Stringifier.new(@segments).stringify}:\n"
  end
end