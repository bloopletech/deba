class Deba::TextRunner
  def initialize(extractor)
    @extractor = extractor
    @text = ""
  end
  
  def <<(segment)
    @text << segment
  end
  
  def start(block_type, param = nil)
    @block_type = block_type
    @param = param
    puts "Starting text run with #{@block_type.inspect}, #{@param.inspect}"
  end

  def finish
    @text = Deba::TextNormaliser.new(@text).normalise
    puts "Finishing text run with #{@block_type.inspect}, #{@param.inspect}, text: #{@text.inspect}"

    if Deba::Utils.present?(@text)
      block = @param.nil? ? @block_type.new(@text) : @block_type.new(@text, @param)
      @extractor.blocks << block
    end

    @text = ""
    @block_type = nil
    @param = nil
  end
end