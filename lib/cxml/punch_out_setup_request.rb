# frozen_string_literal: true

module CXML
  class PunchOutSetupRequest < DocumentNode
    include Extrinsicable

    accessible_attributes %i[
      operation
    ]

    accessible_nodes %i[
      buyer_cookie
      browser_form_post
      supplier_setup
      ship_to
      contact
    ]
  end
end
