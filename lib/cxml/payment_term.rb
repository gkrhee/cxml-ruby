# frozen_string_literal: true

module CXML
  class PaymentTerm < DocumentNode
    include Extrinsicable

    accessible_attributes %i[
      pay_in_number_of_days
    ]
    accessible_nodes %i[
      discount
      net_due_days
    ]
  end
end
