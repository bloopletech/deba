class Deba::TextRunner
  def initialize(extractor)
    @extractor = extractor

    start
  end

  def <<(segment)
    @segments << segment
  end

  def break(block_type = Deba::Paragraph, param = nil)
    finish
    start(block_type, param)
  end

  def finish
    return unless present?

    block = @param.nil? ? @block_type.new(@segments) : @block_type.new(@segments, @param)
    @extractor.blocks << block
  end

  def start(block_type = Deba::Paragraph, param = nil)
    @segments = []
    @block_type = block_type
    @param = param
  end

  def present?
    @segments.any? { |segment| segment.is_a?(String) && Deba::Utils.present?(segment) }
  end
end