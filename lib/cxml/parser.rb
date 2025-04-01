# frozen_string_literal: true

require('xmlsimple')

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
      XmlSimple.xml_in(data, { 'ForceArray' => false })
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
      return value unless value.is_a?(Hash)

      value.transform_keys!(&method(:underscore_key))
      value.transform_values!(&method(:underscore_hash_values))
      value
    end
  end
end
