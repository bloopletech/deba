require "nokogiri"

module Deba
  VERSION = "0.14.0"
end

require "deba/utils"
require "deba/stringifier"
require "deba/span"
require "deba/heading"
require "deba/list_item"
require "deba/definition_term"
require "deba/definition_description"
require "deba/paragraph"
require "deba/document"
require "deba/extractor"

module Deba
  def self.extract(html, options = {})
    doc = html.is_a?(Nokogiri::XML::Node) ? html : Nokogiri.HTML(html)
    Deba::Extractor.new(doc, options).extract
  end
end