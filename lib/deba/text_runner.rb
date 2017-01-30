class Deba::TextRunner
  def initialize(extractor)
    @extractor = extractor
    @segments = []
  end
  
  def <<(segment)
    @segments << segment
  end

  def break(block_type, param = nil)
    if present?
      block = param.nil? ? block_type.new(@segments) : block_type.new(@segments, param)
      @extractor.blocks << block
    end

    @segments = []
  end

  def present?
    @segments.any? { |segment| segment.is_a?(String) && Deba::Utils.present?(segment) }
  end
end