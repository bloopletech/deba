class Deba::Extractor
  HEADING_TAGS = %w(h1 h2 h3 h4 h5 h6)
  BLOCK_INITIATING_TAGS = %w(article aside body blockquote dd dt header li nav ol p pre section td th ul)
  ENHANCERS = { %w(b strong) => "*", %(i em) => "_" }

  attr_reader :blocks

  def initialize(text)
    @doc = Nokogiri::HTML(text)
  end
  
  def extract
    @blocks = []
    @just_appended_br = false

    @text_run = Deba::TextRunner.new(self)
    @text_run.start(Deba::Paragraph)

    process(@doc.root)

    @blocks
  end

  def process(node)
    node_name = node.name.downcase
    puts "node_name: #{node_name}"

    return if node_name == 'head'

    if node.text?
      puts "node.inner_tex): #{node.inner_text.inspect}"
      puts "Deba::Utils.present?(node.inner_text): #{Deba::Utils.present?(node.inner_text)}"
      @text_run << node.inner_text if Deba::Utils.present?(node.inner_text)

      return
    end

    #Handle repeated brs by making a paragraph break
    if node_name == 'br'
      if @just_appended_br
        @just_appended_br = false

        @text_run.finish
        @text_run.start(Deba::Paragraph)

        return
      else
        @just_appended_br = true
      end
    elsif @just_appended_br
      @just_appended_br = false

      @text_run << "\n"

      return
    end

    #These tags terminate the current paragraph, if present, and start a new paragraph
    if BLOCK_INITIATING_TAGS.include?(node_name)
      @text_run.finish
      @text_run.start(Deba::Paragraph)

      node.children.each { |n| process(n) }

      @text_run.finish
      @text_run.start(Deba::Paragraph)

      return
    end
    
    if ENHANCERS.keys.flatten.include?(node_name)
      ENHANCERS.each_pair do |tags, nsf_rep|
        if tags.include?(node_name)
          @text_run << nsf_rep
          node.children.each { |n| process(n) }
          @text_run << nsf_rep
        end
      end

      return
    end
    
    if HEADING_TAGS.include?(node_name)
      @text_run.finish
      @text_run.start(Deba::Heading, node_name[1..-1].to_i)

      node.children.each { |n| process(n) }

      @text_run.finish
      @text_run.start(Deba::Paragraph)

      return
    end

    #Pretend that the children of this node were siblings of this node (move them one level up the tree)
    node.children.each { |n| process(n) }
  end
end