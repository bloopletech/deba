class Deba::DefinitionDescription
  attr_reader :segments

  def initialize(segments, last)
    @segments = segments
    @last = last
  end

  def to_s
    "#{Deba::Stringifier.new(@segments).stringify}\n#{"\n" if @last}"
  end
end