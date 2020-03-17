# frozen_string_literal: true

require './discounts'
require 'discount_adapter'

class Checkout
  attr_reader :prices, :discounts
  private :prices, :discounts

  def initialize(prices)
    @prices = prices
    @discounts = DiscountsDatabase::DISCOUNTS
  end

  def scan(item)
    basket << BasketItem.new(item.to_sym, 1)
  end

  def total
    priced_items.map(&:price).sum
  end

  private

  def priced_items
    grouped_basket_items.each_with_object([]) do |item, items|
      items << PricedItem.new(item.name, calculate_price(item))
    end
  end

  def grouped_basket_items
    basket.each_with_object([]) do |basket_item, items|
      if items.any? { |item| item.name == basket_item.name }
        items.find { |item| item.name == basket_item.name }
             .quantity += basket_item.quantity
      else
        items << BasketItem.new(basket_item.name, basket_item.quantity)
      end
    end
  end

  def basket
    @basket ||= []
  end

  def calculate_price(item)
    selected_discount = select_discount_for(item)

    unless selected_discount.nil?
      discount_price = DiscountAdapter.new(prices, item)
                                      .apply(selected_discount)
    end

    discount_price || standard_price(item)
  end

  def select_discount_for(item)
    discounts.find do |discount|
      discount[:applies_to].include?(item.name)
    end
  end

  def standard_price(item)
    prices.fetch(item.name) * item.quantity
  end

  BasketItem = Struct.new(:name, :quantity)
  PricedItem = Struct.new(:name, :price)
end
