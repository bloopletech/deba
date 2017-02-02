class Deba::DefinitionDescription
  attr_reader :segments

  def initialize(segments, line_prefix, last)
    @segments = segments
    @line_prefix = line_prefix
    @last = last
  end

  def to_s
    "#{Deba::Stringifier.new(@segments, @line_prefix).stringify}\n#{"\n" if @last}"
  end
end