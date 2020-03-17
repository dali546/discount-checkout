# frozen_string_literal: true

class DiscountsDatabase
  DISCOUNTS = [
    {
      applies_to: %i[apple pear],
      discount_type: :two_for_one
    },
    {
      applies_to: %i[pineapple],
      discount_type: :half_price_on_one_item
    },
    {
      applies_to: %i[banana],
      discount_type: :half_price
    },
    {
      applies_to: %i[mango],
      discount_type: :buy_three_get_one_free
    }
  ].freeze
end
