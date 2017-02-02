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

        @text_run.break(Deba::Paragraph, line_prefix(node))

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

    if node_name == 'li'
      last_item = node.xpath('count(following-sibling::li)').to_i == 0
      index = node.xpath('boolean(ancestor::ol)') ? (node.xpath('count(preceding-sibling::li)').to_i + 1) : nil
      @text_run.break(Deba::ListItem, line_prefix(node), last_item, index)
      node.children.each { |n| process(n) }
      @text_run.break(Deba::Paragraph, line_prefix(node))

      return
    end

    if node_name == 'dt'
      @text_run.break(Deba::DefinitionTerm, line_prefix(node))
      node.children.each { |n| process(n) }
      @text_run.break(Deba::Paragraph, line_prefix(node))

      return
    end

    if node_name == 'dd'
      last_item = node.xpath('count(following-sibling::dd)').to_i == 0
      @text_run.break(Deba::DefinitionDescription, line_prefix(node), last_item)
      node.children.each { |n| process(n) }
      @text_run.break(Deba::Paragraph, line_prefix(node))

      return
    end

    #These tags terminate the current paragraph, if present, and start a new paragraph
    if BLOCK_INITIATING_TAGS.include?(node_name)
      @text_run.break(Deba::Paragraph, line_prefix(node))
      node.children.each { |n| process(n) }
      @text_run.break(Deba::Paragraph, line_prefix(node))

      return
    end

    if HEADING_TAGS.include?(node_name)
      @text_run.break(Deba::Heading, node_name[1..-1].to_i)
      node.children.each { |n| process(n) }
      @text_run.break(Deba::Paragraph, line_prefix(node))

      return
    end

    #Pretend that the children of this node were siblings of this node (move them one level up the tree)
    node.children.each { |n| process(n) }
  end

  def line_prefix(node)
    if node.xpath('boolean(ancestor::blockquote)')
      Deba::Blockquote.new
    else
      nil
    end
  end
end