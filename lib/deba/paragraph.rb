class Deba::Paragraph
  attr_reader :segments

  def initialize(segments, line_prefix)
    @segments = segments
    @line_prefix = line_prefix
  end

  def to_s
    "#{Deba::Stringifier.new(@segments, line_prefix: @line_prefix).stringify}\n\n"
  end
end