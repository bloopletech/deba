class Deba::Extractor
  HEADING_TAGS = %w(h1 h2 h3 h4 h5 h6)
  BLOCK_INITIATING_TAGS = %w(
    address
    article
    aside
    body
    blockquote
    div
    dd
    dl
    dt
    figure
    footer
    header
    li
    main
    nav
    ol
    p
    pre
    section
    td
    th
    ul)
  ENHANCERS = { %w(b strong) => "*", %w(i em) => "_" }
  SKIP_TAGS = %w(
    head
    style
    script
  )

  attr_reader :blocks

  def initialize(doc, options = {})
    @node = doc.root
    @options = options
  end

  def extract
    @just_appended_br = false
    @in_blockquote = false
    @document = Deba::Document.new(self)

    process(@node)

    @document.content.chomp("\n")
  end

  def process(node)
    if @options.key?(:exclude)
      return if Array(@options[:exclude]).any? { |selector| node.matches?(selector) }
    end

    node_name = node.name.downcase

    return if SKIP_TAGS.include?(node_name)

    #Handle repeated brs by making a paragraph break
    if node_name == 'br'
      if @just_appended_br
        @just_appended_br = false

        @document.break(Deba::Paragraph)

        return
      else
        @just_appended_br = true
      end
    elsif @just_appended_br
      @just_appended_br = false

      @document << "\n"
    end

    if node.text?
      @document << Deba::Span.new(node.inner_text) if Deba::Utils.present?(node.inner_text)

      return
    end

    if ENHANCERS.keys.flatten.include?(node_name)
      ENHANCERS.each_pair do |tags, nsf_rep|
        if tags.include?(node_name)
          @document << nsf_rep
          node.children.each { |n| process(n) }
          @document << nsf_rep
        end
      end

      return
    end

    if node_name == 'blockquote'
      @in_blockquote = true

      @document.break(Deba::Paragraph)
      node.children.each { |n| process(n) }
      @document.break(Deba::Paragraph)

      @in_blockquote = false

      return
    end

    if node_name == 'li'
      last_item = node.xpath('count(following-sibling::li)').to_i == 0
      index = node.xpath('boolean(ancestor::ol)') ? (node.xpath('count(preceding-sibling::li)').to_i + 1) : nil

      @document.break(Deba::ListItem, last_item, index)
      node.children.each { |n| process(n) }
      @document.break(Deba::Paragraph)

      return
    end

    if node_name == 'dt'
      @document.break(Deba::DefinitionTerm)
      node.children.each { |n| process(n) }
      @document.break(Deba::Paragraph)

      return
    end

    if node_name == 'dd'
      last_item = node.xpath('count(following-sibling::dd)').to_i == 0
      @document.break(Deba::DefinitionDescription, last_item)
      node.children.each { |n| process(n) }
      @document.break(Deba::Paragraph)

      return
    end

    #These tags terminate the current paragraph, if present, and start a new paragraph
    if BLOCK_INITIATING_TAGS.include?(node_name)
      @document.break(Deba::Paragraph)
      node.children.each { |n| process(n) }
      @document.break(Deba::Paragraph)

      return
    end

    if HEADING_TAGS.include?(node_name)
      @document.break(Deba::Heading, node_name[1..-1].to_i)
      node.children.each { |n| process(n) }
      @document.break(Deba::Paragraph)

      return
    end

    #Pretend that the children of this node were siblings of this node (move them one level up the tree)
    node.children.each { |n| process(n) }
  end

  def in_blockquote?
    @in_blockquote
  end
end