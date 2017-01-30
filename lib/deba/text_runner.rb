class Deba::TextRunner
  def initialize(document)
    @document = document

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
    @document << @block_type.new(*@args)
  end

  def start(*args)
    @segments = []
    @block_type = args.shift
    @args = args
  end

  def present?
    @segments.any? { |segment| segment.is_a?(String) && Deba::Utils.present?(segment) }
  end
end