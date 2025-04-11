# frozen_string_literal: true

module CXML
  class ConfirmationStatus < DocumentNode
    include Extrinsicable

    accessible_attributes %i[
      quantity
      type
      shipment_date
      delivery_date
    ]
    accessible_nodes %i[
      comments
      unit_of_measure
      unit_price
    ]
  end
end
