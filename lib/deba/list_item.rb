class Deba::ListItem
  attr_reader :segments

  def initialize(segments, last, index)
    @segments = segments
    @last = last
    @index = index
  end

  def to_s
    prefix = if @index.nil?
      "* "
    else
      "#{@index}. "
    end

    "#{prefix}#{Deba::Stringifier.new(@segments).stringify}\n#{"\n" if @last}"
  end
end