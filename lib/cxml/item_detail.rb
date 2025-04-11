# frozen_string_literal: true

module CXML
  class ItemDetail < DocumentNode
    include Extrinsicable

    accessible_nodes %i[
      unit_price
      description
      unit_of_measure
      classification
      manufacturer_part_id
      manufacturer_name
      url
      lead_time
    ]
  end
end
