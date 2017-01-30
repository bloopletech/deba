require "nokogiri"

module Deba
  VERSION = "0.2.0"
end

require "deba/utils"
require "deba/stringifier"
require "deba/document"
require "deba/break"
require "deba/heading"
require "deba/paragraph"
require "deba/text_runner"
require "deba/extractor"

module Deba
  def self.extract(html)
    Deba::Extractor.new(html.is_a?(Nokogiri::XML::Node) ? html : Nokogiri::HTML(html)).extract
  end
end