class Deba::Paragraph
  attr_reader :segments

  def initialize(segments)
    @segments = segments
  end

  def to_s
    "#{Deba::Stringifier.new(@segments).stringify}\n\n"
  end
end