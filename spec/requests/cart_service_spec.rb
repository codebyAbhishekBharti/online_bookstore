require 'rails_helper'

RSpec.describe CartsService, type: :service do
  let(:user) { create(:user) }
  let(:book) { create(:book, stock_quantity: 10) }

  describe '.add_item_to_cart' do
    context 'with valid params' do
      it 'adds the item to the cart' do
        params = { book_id: book.id, quantity: 2 }
        cart_item = described_class.add_item_to_cart(user.id, params)
        expect(cart_item).to be_persisted
        expect(cart_item.book_id).to eq(book.id)
      end
    end

    context 'with missing user_id' do
      it 'raises MissingParameterError' do
        params = { book_id: book.id, quantity: 1 }
        expect {
          described_class.add_item_to_cart(nil, params)
        }.to raise_error(CartErrors::MissingParameterError)
      end
    end

    context 'with invalid quantity' do
      it 'raises InvalidQuantityError' do
        params = { book_id: book.id, quantity: 0 }
        expect {
          described_class.add_item_to_cart(user.id, params)
        }.to raise_error(CartErrors::InvalidQuantityError)
      end
    end

    context 'with insufficient stock' do
      it 'raises InsufficientStockError' do
        params = { book_id: book.id, quantity: 20 }
        expect {
          described_class.add_item_to_cart(user.id, params)
        }.to raise_error(CartErrors::InsufficientStockError)
      end
    end
  end

  describe '.get_cart_items' do
    context 'when cart has items' do
      it 'returns the items' do
        create(:cart, user: user, book: book, quantity: 1)
        items = described_class.get_cart_items(user.id)
        expect(items.count).to eq(1)
      end
    end

    context 'when cart is empty' do
      it 'raises CartItemNotFoundError' do
        expect {
          described_class.get_cart_items(user.id)
        }.to raise_error(CartErrors::CartItemNotFoundError)
      end
    end
  end

  describe '.delete_cart_item' do
    let!(:cart_item) { create(:cart, user: user, book: book) }

    it 'deletes the cart item' do
      expect {
        described_class.delete_cart_item(user.id, { id: cart_item.id })
      }.to change { Cart.count }.by(-1)
    end

    it 'raises CartItemNotFoundError for invalid ID' do
      expect {
        described_class.delete_cart_item(user.id, { id: 0 })
      }.to raise_error(CartErrors::CartItemNotFoundError)
    end
  end

  describe '.update_cart_item' do
    let!(:cart_item) { create(:cart, user: user, book: book, quantity: 2) }

    it 'updates the quantity' do
      updated = described_class.update_cart_item(user.id, { id: cart_item.id, quantity: 5 })
      expect(updated.quantity).to eq(5)
    end

    it 'raises InvalidQuantityError for invalid quantity' do
      expect {
        described_class.update_cart_item(user.id, { id: cart_item.id, quantity: 0 })
      }.to raise_error(CartErrors::InvalidQuantityError)
    end

    it 'raises InsufficientStockError if quantity exceeds stock' do
      expect {
        described_class.update_cart_item(user.id, { id: cart_item.id, quantity: 100 })
      }.to raise_error(CartErrors::InsufficientStockError)
    end

    it 'raises CartItemNotFoundError for invalid cart item' do
      expect {
        described_class.update_cart_item(user.id, { id: 999, quantity: 1 })
      }.to raise_error(CartErrors::CartItemNotFoundError)
    end
  end
end
