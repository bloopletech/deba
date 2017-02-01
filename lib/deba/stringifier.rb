class Deba::Stringifier
  def initialize(segments, options = {})
    @segments = segments
    @options = options
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
    if @options.key?(:prefix)
      text.gsub!(/\A/s, @options[:prefix].to_s)
    end

    if @options.key?(:subsequent_line_prefix)
      text.gsub!(/(?<=\n)^/, @options[:subsequent_line_prefix].to_s)
    end

    if @options.key?(:line_prefix)
      text.gsub!(/^/, @options[:line_prefix].to_s)
    end

    text
  end
end