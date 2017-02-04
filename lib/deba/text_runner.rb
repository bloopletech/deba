class Deba::TextRunner
  attr_reader :document

  def initialize(extractor)
    @extractor = extractor
    @document = ""

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
    content = @block_type.new(*@args).to_a
    content.unshift("> ") if @extractor.in_blockquote?

    @document << Deba::Stringifier.new(content).stringify
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