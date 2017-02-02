require "nokogiri"

module Deba
  VERSION = "0.10.0"
end

require "deba/utils"
require "deba/stringifier"
require "deba/document"
require "deba/break"
require "deba/heading"
require "deba/list_item"
require "deba/blockquote"
require "deba/definition_term"
require "deba/definition_description"
require "deba/paragraph"
require "deba/text_runner"
require "deba/extractor"

module Deba
  def self.extract(html, options = {})
    document(html, options).to_s
  end

  def self.document(html, options = {})
    doc = html.is_a?(Nokogiri::XML::Node) ? html : Nokogiri.HTML(html)
    Deba::Extractor.new(doc, options).extract
  end
end