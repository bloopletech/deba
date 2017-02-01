class Deba::Stringifier
  def initialize(segments, line_prefix = nil)
    @segments = segments
    @line_prefix = line_prefix
  end

  def stringify
    prefix(chunkify)
  end

  def chunkify
    chunks = @segments.chunk { |segment| segment.class }

    chunks.map do |type, chunk_segments|
      if type == String
        Deba::Utils.normalise(chunk_segments.join)
      elsif type == Deba::Break
        chunk_segments.map { |s| s.to_s }.join
      end
    end.join
  end

  def prefix(text)
    return text if @line_prefix.nil?

    text.gsub(/^/, @line_prefix.to_s)
  end
end