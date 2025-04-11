# frozen_string_literal: true

module CXML
  class Tax < DocumentNode
    include Extrinsicable

    accessible_nodes %i[
      money
      tax_adjustment_amount
      description
      tax_details
      distribution
    ]

    def initialize_tax_detail(value)
      value = [value] unless value.is_a?(Array)
      @tax_details = value.map do |item|
        TaxDetail.new(item)
      end
    end

    def initialize_tax_details(value)
      value = [value] unless value.is_a?(Array)
      @tax_details = value.map do |item|
        TaxDetail.new(item)
      end
    end
  end
end
