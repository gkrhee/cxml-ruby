# frozen_string_literal: true

require('nokogiri')
require('nori')

Nori::StringWithAttributes.class_eval do
  def [](*args)
    val = attributes[args.first] if args.count > 0
    val || super
  end
  def ==(other)
    if other.is_a?(Hash)
      return true if {content: self.to_s}.merge(attributes) == other
    end
    super
  end
end

module CXML
  class Parser
    attr_accessor :data,
                  :parsed_data

    def initialize(data:)
      @data = data
    end

    def parse
      @parsed_data = transform_hash document
      if dtd_url
        @parsed_data[:version] = version
        @parsed_data[:dtd] = dtd
      end
      @parsed_data
    end

    def document
      attribute_converter = lambda { |tag| tag.start_with?("@") ? tag.gsub(/@/, "") : tag }
      hash = Nori.new(parser: :nokogiri, convert_tags_to: attribute_converter).parse(data)
      hash = hash.first[1] if hash.is_a?(Hash) && !hash.empty?
      hash
    end

    def version
      dtd_url&.match(%r{cXML/(.*)/.*\.dtd})&.to_a&.last
    end

    def dtd
      dtd_url&.match(%r{cXML/.*/(.*)\.dtd})&.to_a&.last
    end

    def dtd_url
      return nil unless @doc_type_string

      @doc_type_string.match(/http.*\.dtd/)&.to_a&.first
    end

    private

    def transform_hash(hash)
      hash.transform_keys!(&method(:underscore_key))
      hash.transform_values!(&method(:underscore_hash_values))
    end

    def underscore_key(key)
      return key.to_s.to_sym unless /[A-Z-]|:/.match?(key)

      word = key.to_s.gsub(':', '_')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!('-', '_')
      word.downcase!
      word.to_sym
    end

    def underscore_hash_values(value)
      return value.map(&method(:underscore_hash_values)) if value.is_a?(Array)
      if value.is_a?(Nori::StringWithAttributes)
        value.attributes.transform_keys!(&method(:underscore_key))
      end
      return value unless value.is_a?(Hash)

      value.transform_keys!(&method(:underscore_key))
      value.transform_values!(&method(:underscore_hash_values))
      value
    end
  end
end
