class Deba::ListItem
  attr_reader :segments

  def initialize(segments, line_prefix, last, index)
    @segments = segments
    @line_prefix = line_prefix
    @last = last
    @index = index
  end

  def to_s
    prefix = if @index.nil?
      "* "
    else
      "#{@index}. "
    end

    @segments.unshift(prefix)

    "#{Deba::Stringifier.new(@segments, @line_prefix).stringify}\n#{"\n" if @last}"
  end
end