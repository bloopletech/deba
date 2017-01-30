class Deba::Document
  attr_reader :blocks

  def initialize
    @blocks = []
  end

  def <<(block)
    @blocks << block
  end

  def to_s
    @blocks.map { |block| block.to_s }.join.strip
  end
end