# frozen_string_literal: true

require 'spec_helper'
require 'discount_adapter'
require 'checkout'

RSpec.describe DiscountAdapter do
  describe '#apply' do
    subject { described_class.new(prices, item).apply(discount) }

    let(:prices) {
      {
        apple: 10,
        orange: 20,
        pear: 15,
        banana: 30,
        pineapple: 100,
        mango: 200
      }
    }

    context 'when a half price discount is selected' do
      let(:discount) {
        {
          applies_to: %i[banana],
          discount_type: :half_price
        }
      }
      let(:item) {
        Checkout::BasketItem.new(:banana, 3)
      }

      it 'is expected to be half price' do
        expect(subject).to eq(45)
      end
    end

    context 'when a buy three get one free discount is selected' do
      let(:discount) {
        {
          applies_to: %i[mango],
          discount_type: :buy_three_get_one_free
        }
      }
      let(:item) {
        Checkout::BasketItem.new(:mango, 4)
      }

      it 'is expected to be applied' do
        expect(subject).to eq(600)
      end
      

      context 'but does not meet the quantity' do
        let(:item) {
          Checkout::BasketItem.new(:mango, 2)
        }

        it 'is expected to return nil' do
          expect(subject).to eq(nil)
        end
      end
    end

    context 'when a half price on one item discount is selected' do
      let(:discount) {
        {
          applies_to: %i[pineapple],
          discount_type: :half_price_on_one_item
        }
      }
      let(:item) {
        Checkout::BasketItem.new(:pineapple, 3)
      }

      it 'is expected to be applied' do
        expect(subject).to eq(250)
      end
    end

    context 'when a two for one discount is selected' do
      let(:discount) {
        {
          applies_to: %i[apple pear],
          discount_type: :two_for_one
        }
      }
      let(:item) {
        Checkout::BasketItem.new(:pear, 4)
      }

      it 'is expected to be applied' do
        expect(subject).to eq(30)
      end
    end
  end
end
