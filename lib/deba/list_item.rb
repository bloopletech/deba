class Deba::ListItem
  attr_reader :segments

  def initialize(segments, line_prefix, last, index)
    @segments = segments
    @line_prefix = line_prefix
    @last = last
    @index = index
  end

  def to_s
    "#{Deba::Stringifier.new([prefix] + @segments, @line_prefix).stringify}\n#{"\n" if @last}"
  end

  def prefix
    if @index.nil?
      "* "
    else
      "#{@index}. "
    end
  end
end