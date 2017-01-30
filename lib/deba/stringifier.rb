class Deba::Stringifier
  def initialize(segments)
    @segments = segments
  end

  def stringify
    chunks = @segments.chunk { |segment| segment.class }

    chunks.map do |type, chunk_segments|
      if type == String
        Deba::Utils.normalise(chunk_segments.join)
      elsif type == Deba::Break
        chunk_segments.map { |s| s.to_s }.join
      end
    end.join
  end
end