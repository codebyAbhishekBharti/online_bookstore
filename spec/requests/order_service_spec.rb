# spec/services/order_service_spec.rb

require 'rails_helper'

RSpec.describe OrderService, type: :service do
  let(:user) { create(:user) }
  let(:address) { create(:address, user: user) }
  let(:cart_item) { create(:cart_item, user: user) }
  let(:book) { create(:book) }

  describe '.create_order' do
    let(:params) do
      {
        cart_ids: [cart_item.id],
        address_id: address.id
      }
    end

    context 'when cart IDs and address ID are missing' do
      it 'raises MissingParameterError' do
        expect { OrderService.create_order(user.id, {}) }
          .to raise_error(OrderErrors::MissingParameterError, "Cart IDs and Address ID are required")
      end
    end

    context 'when the address is not found' do
      it 'raises AddressNotFoundError' do
        expect { OrderService.create_order(user.id, params.merge(address_id: 999)) }
          .to raise_error(OrderErrors::AddressNotFoundError)
      end
    end

    context 'when cart item or book is not found' do
      it 'raises CartItemNotFoundError' do
        expect { OrderService.create_order(user.id, params.merge(cart_ids: [999])) }
          .to raise_error(OrderErrors::CartItemNotFoundError)
      end

      it 'raises BookNotFoundError' do
        cart_item.update(book_id: 999)
        expect { OrderService.create_order(user.id, params) }
          .to raise_error(OrderErrors::BookNotFoundError)
      end
    end

    context 'when everything is valid' do
      it 'creates a new order' do
        expect { OrderService.create_order(user.id, params) }.to change(Order, :count).by(1)
      end
    end
  end

  describe '.get_all_orders' do
    context 'when orders are found' do
      it 'returns all orders for the user' do
        create(:order, user: user)
        orders = OrderService.get_all_orders(user.id)
        expect(orders.count).to be > 0
      end
    end

    context 'when no orders are found' do
      it 'raises OrdersNotFoundError' do
        expect { OrderService.get_all_orders(user.id) }
          .to raise_error(OrderErrors::OrdersNotFoundError)
      end
    end
  end

  describe '.get_order_details' do
    let(:order) { create(:order, user: user) }

    context 'when the order is found' do
      it 'returns the order' do
        order_details = OrderService.get_order_details(user.id, order.id)
        expect(order_details).to eq(order)
      end
    end

    context 'when the order is not found' do
      it 'raises OrderNotFoundError' do
        expect { OrderService.get_order_details(user.id, 999) }
          .to raise_error(OrderErrors::OrderNotFoundError)
      end
    end
  end

  describe '.update_order_address' do
    let(:order) { create(:order, user: user, shipment_address: address) }

    context 'when order is found and updated' do
      it 'updates the order address successfully' do
        new_address = create(:address, user: user)
        params = { order_id: order.id, full_name: new_address.full_name }
        
        allow(ShipmentAddressService).to receive(:update_address).and_return(true)
        
        expect { OrderService.update_order_address(user.id, params) }
          .not_to raise_error
      end
    end

    context 'when order update fails' do
      it 'raises OrderUpdateError' do
        params = { order_id: order.id, full_name: nil }
        allow(ShipmentAddressService).to receive(:update_address).and_raise(StandardError)
        
        expect { OrderService.update_order_address(user.id, params) }
          .to raise_error(OrderErrors::OrderUpdateError)
      end
    end
  end

  describe '.delete_order' do
    let(:order) { create(:order, user: user, status: 'pending') }

    context 'when the order is deleted successfully' do
      it 'deletes the order' do
        expect { OrderService.delete_order(user.id, order.id) }.to change(Order, :count).by(-1)
      end
    end

    context 'when the order status is shipped or delivered' do
      it 'raises OrderDeletionForbiddenError' do
        order.update(status: 'shipped')
        expect { OrderService.delete_order(user.id, order.id) }
          .to raise_error(OrderErrors::OrderDeletionForbiddenError)
      end
    end

    context 'when deletion fails due to other reasons' do
      it 'raises OrderDeletionError' do
        allow(order).to receive(:destroy!).and_raise(StandardError)
        expect { OrderService.delete_order(user.id, order.id) }
          .to raise_error(OrderErrors::OrderDeletionError)
      end
    end
  end
end
