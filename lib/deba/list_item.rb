class Deba::ListItem
  attr_reader :segments

  def initialize(segments, last, index)
    @segments = segments
    @last = last
    @index = index
  end

  def to_s
    if @segments.first.is_a?(Deba::Blockquote)
      @segments.insert(1, prefix)
    else
      @segments.unshift(prefix)
    end

    "#{Deba::Stringifier.new(@segments).stringify}\n#{"\n" if @last}"
  end

  def prefix
    if @index.nil?
      "* "
    else
      "#{@index}. "
    end
  end
end