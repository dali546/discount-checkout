# frozen_string_literal: true

class Checkout
  attr_reader :prices, :discounts
  private :prices, :discounts

  def initialize(prices)
    @prices = prices
  end

  def scan(item)
    basket << item.to_sym
  end

  def total
    priced_items.values.sum
  end

  def priced_items
    collected_items.each_with_object(Hash.new(0)) do |item, items|
      items[item[0]] = price_item(item)
    end
  end

  def collected_items
    basket.each_with_object(Hash.new(0)) do |item, items|
      items[item] += 1
    end
  end

  def price_item(item)
    if %i[apple pear].include?(item[0])
      buy_two_for_one(item)
    elsif item[0] == :pineapple
      (prices.fetch(item[0]) / 2) + prices.fetch(item[0]) * (item[1] - 1)
    elsif item[0] == :banana
      (prices.fetch(item[0]) / 2) * item[1]
    elsif item[0] == :mango
      if (item[1] % 4).zero?
        (prices.fetch(item[0]) * (item[1] - 1))
      else
        prices.fetch(item[0]) * item[1]
      end
    else
      prices.fetch(item[0]) * item[1]
    end
  end

  def buy_two_for_one(item)
    if (item[1] % 2).zero?
      prices.fetch(item[0]) * (item[1] / 2)
    else
      prices.fetch(item[0]) * item[1]
    end
  end

  private

  def basket
    @basket ||= []
  end
end
