class Deba::Heading
  attr_reader :segments, :level

  def initialize(segments, level)
    @segments = segments
    @level = level
  end

  def to_s
    "#{"#" * @level} #{Deba::Stringifier.new(@segments).stringify}\n\n"
  end
end