class Deba::ListItem
  def initialize(segments, last, index)
    @segments = segments
    @last = last
    @index = index
  end

  def to_a
    [prefix] + @segments + ["\n#{"\n" if @last}"]
  end

  def prefix
    if @index.nil?
      "* "
    else
      "#{@index}. "
    end
  end
end