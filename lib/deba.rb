require "nokogiri"

module Deba
end

require "deba/version"
require "deba/utils"
require "deba/stringifier"
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