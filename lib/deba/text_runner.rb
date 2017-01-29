class Deba::TextRunner
  def initialize(extractor)
    @extractor = extractor
    @text = []
  end
  
  def <<(segment)
    @text << segment
  end

  def break(block_type, param = nil)
    chunks = @text.chunk { |segment| segment.class }
    text = chunks.map do |type, segments|
      if type == String
        Deba::Utils.normalise(segments.join)
      elsif type == Deba::Break
        segments.map { |_| "\n" }
      end
    end.join

    if Deba::Utils.present?(text)
      block = param.nil? ? block_type.new(text) : block_type.new(text, param)
      @extractor.blocks << block
    end

    @text = []
  end
end