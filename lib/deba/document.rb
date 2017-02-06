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

    @content << BLOCKQUOTE if @extractor.in_blockquote?
    @content << block_content
  end

  def start(*args)
    @segments = []
    @args = args
  end

  def present?
    @segments.any? { |segment| segment.is_a?(Deba::Span) && Deba::Utils.present?(segment.to_s) }
  end

  def block_content
    block_type = @args.shift
    @args.unshift(@segments)
    Deba::Stringifier.new(block_type.new(*@args).to_a).stringify
  end
end