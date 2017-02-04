class Deba::Stringifier
  def initialize(segments)
    @segments = segments
  end

  def stringify
    chunks = @segments.chunk { |segment| segment.class }

    chunks.map do |type, chunk_segments|
      if type == Deba::Span
        Deba::Utils.normalise(chunk_segments.map { |s| s.to_s }.join)
      else
        chunk_segments.join
      end
    end.join
  end
end