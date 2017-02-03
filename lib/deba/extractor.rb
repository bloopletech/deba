class Deba::Extractor
  HEADING_TAGS = %w(h1 h2 h3 h4 h5 h6)
  BLOCK_INITIATING_TAGS = %w(article aside body blockquote dd dt header li nav ol p pre section td th ul)
  ENHANCERS = { %w(b strong) => "*", %w(i em) => "_" }

  attr_reader :blocks

  def initialize(doc, options = {})
    @node = doc.root
    @options = options
  end

  def extract
    @just_appended_br = false
    @in_blockquote = false
    @document = Deba::Document.new
    @text_run = Deba::TextRunner.new(@document)

    process(@node)

    @document
  end

  def process(node)
    if @options.key?(:exclude)
      return if Array(@options[:exclude]).any? { |selector| node.matches?(selector) }
    end

    node_name = node.name.downcase

    return if node_name == 'head'

    #Handle repeated brs by making a paragraph break
    if node_name == 'br'
      if @just_appended_br
        @just_appended_br = false

        block(Deba::Paragraph)

        return
      else
        @just_appended_br = true
      end
    elsif @just_appended_br
      @just_appended_br = false

      @text_run << Deba::Break.new
    end

    if node.text?
      @text_run << node.inner_text if Deba::Utils.present?(node.inner_text)

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

    if node_name == 'blockquote'
      @in_blockquote = true

      block(Deba::Paragraph)
      node.children.each { |n| process(n) }
      block(Deba::Paragraph)

      @in_blockquote = false

      return
    end

    if node_name == 'li'
      last_item = node.xpath('count(following-sibling::li)').to_i == 0
      index = node.xpath('boolean(ancestor::ol)') ? (node.xpath('count(preceding-sibling::li)').to_i + 1) : nil
      
      block(Deba::ListItem, last_item, index)
      node.children.each { |n| process(n) }
      block(Deba::Paragraph)

      return
    end

    if node_name == 'dt'
      block(Deba::DefinitionTerm)
      node.children.each { |n| process(n) }
      block(Deba::Paragraph)

      return
    end

    if node_name == 'dd'
      last_item = node.xpath('count(following-sibling::dd)').to_i == 0
      block(Deba::DefinitionDescription, last_item)
      node.children.each { |n| process(n) }
      block(Deba::Paragraph)

      return
    end

    #These tags terminate the current paragraph, if present, and start a new paragraph
    if BLOCK_INITIATING_TAGS.include?(node_name)
      block(Deba::Paragraph)
      node.children.each { |n| process(n) }
      block(Deba::Paragraph)

      return
    end

    if HEADING_TAGS.include?(node_name)
      block(Deba::Heading, node_name[1..-1].to_i)
      node.children.each { |n| process(n) }
      block(Deba::Paragraph)

      return
    end

    #Pretend that the children of this node were siblings of this node (move them one level up the tree)
    node.children.each { |n| process(n) }
  end

  def block(*args)
    @text_run.break(*args)
    @text_run << Deba::Blockquote.new if @in_blockquote
  end
end