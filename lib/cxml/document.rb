# frozen_string_literal: true

module CXML
  class Document < DocumentNode
    attr_writer :dtd

    accessible_attributes %i[
      payload_id
      timestamp
      version
      xml_lang
    ]
    accessible_nodes %i[
      header
      message
      request
      response
    ]

    def initialize_timestamp(value)
      @timestamp = Time.parse(value)
    end

    def timestamp
      @timestamp ||= Time.now.utc
    end

    def version
      @version ||= '1.2.037'
    end

    def dtd
      @dtd ||= 'cXML'
    end

    # Check if document is request
    # @return [Boolean]
    def request?
      !request.nil?
    end

    # Check if document is a response
    # @return [Boolean]
    def response?
      !response.nil?
    end

    # Check if document is a message
    # @return [Boolean]
    def message?
      !message.nil?
    end

    def from_xml(xml_string)
      initialize(Parser.new(data: xml_string).parse)
      self
    end

    def to_xml
      node = Nokogiri::XML::Builder.new(encoding: 'UTF-8')
      node.doc.create_internal_subset(dtd, nil, dtd_url)
      node.cXML(node_attributes) do |doc|
        header&.render(doc)
        request&.render(doc)
        response&.render(doc)
        message&.render(doc)
      end
      node.to_xml
    end

    def node_name
      'cXML'
    end

    def dtd_url
      "http://xml.cxml.org/schemas/cXML/#{version}/#{dtd}.dtd"
    end
  end
end
