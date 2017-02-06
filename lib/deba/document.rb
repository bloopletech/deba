class Deba::Document
  BLOCKQUOTE = "> "

  attr_reader :content

  def initialize(extractor)
    @extractor = extractor
    @content = ""

    start
  end

  def <<(segment)
    @segments << segment
  end

  def break(*args)
    finish
    start(*args)
  end

  def finish
    return unless present?

    @args.unshift(@segments)
    block = @block_type.new(*@args).to_a
    block.unshift(BLOCKQUOTE) if @extractor.in_blockquote?

    @content << Deba::Stringifier.new(block).stringify
  end

  def start(*args)
    @segments = []
    @block_type = args.shift
    @args = args
  end

  def present?
    @segments.any? { |segment| segment.is_a?(Deba::Span) && Deba::Utils.present?(segment.to_s) }
  end
end