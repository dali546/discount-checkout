# frozen_string_literal: true

class DiscountAdapter
  attr_reader :prices, :item
  private :prices, :item

  def initialize(prices, item)
    @prices = prices
    @item = item
  end

  def apply(discount)
    send(discount[:discount_type])
  end

  def buy_three_get_one_free
    return unless (item.quantity % 4).zero?

    (prices.fetch(item.name) * (item.quantity - 1))
  end

  def half_price
    (prices.fetch(item.name) / 2) * item.quantity
  end

  def half_price_on_one_item
    prices.fetch(item.name) / 2 + prices.fetch(item.name) * (item.quantity - 1)
  end

  def two_for_one
    return unless (item.quantity % 2).zero?

    prices.fetch(item.name) * (item.quantity / 2)
  end
end
