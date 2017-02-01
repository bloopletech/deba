require "nokogiri"

module Deba
  VERSION = "0.6.0"
end

require "deba/utils"
require "deba/stringifier"
require "deba/document"
require "deba/break"
require "deba/heading"
require "deba/list_item"
require "deba/paragraph"
require "deba/text_runner"
require "deba/extractor"

module Deba
  def self.extract(html)
    document(html).to_s
  end

  def self.document(html)
    Deba::Extractor.new(html.is_a?(Nokogiri::XML::Node) ? html : Nokogiri.HTML(html)).extract
  end
end