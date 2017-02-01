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

    options = {
      prefix: prefix,
      subsequent_line_prefix: " " * prefix.length,
      line_prefix: @line_prefix
    }

    "#{Deba::Stringifier.new(@segments, options).stringify}\n#{"\n" if @last}"
  end
end