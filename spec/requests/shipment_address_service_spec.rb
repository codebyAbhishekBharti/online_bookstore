require 'rails_helper'

RSpec.describe ShipmentAddressService, type: :service do
  let(:valid_params) do
    {
      full_name: "John Doe",
      phone_number: "1234567890",
      address_line1: "123 Main St",
      address_line2: "Apt 4B",
      city: "City",
      state: "State",
      zip_code: "12345",
      country: "Country",
      address_type: "home"
    }
  end

  let(:invalid_params) do
    {
      full_name: "",
      phone_number: "1234567890",
      address_line1: "123 Main St",
      address_line2: "Apt 4B",
      city: "City",
      state: "State",
      zip_code: "12345",
      country: "Country",
      address_type: "home"
    }
  end

  describe '.get_all_addresses' do
    it 'returns all addresses' do
      create(:shipment_address) # Ensure there's at least one address in the database
      addresses = ShipmentAddressService.get_all_addresses
      expect(addresses).not_to be_empty
      expect(addresses.first).to be_a(ShipmentAddress)
    end
  end

  describe '.create_address' do
    context 'with valid parameters' do
      it 'creates a new address' do
        expect {
          ShipmentAddressService.create_address(valid_params)
        }.to change { ShipmentAddress.count }.by(1)
      end

      it 'returns the created address' do
        address = ShipmentAddressService.create_address(valid_params)
        expect(address).to be_persisted
        expect(address.full_name).to eq(valid_params[:full_name])
      end
    end

    context 'with invalid parameters' do
      it 'raises a ShipmentAddressCreationError' do
        expect {
          ShipmentAddressService.create_address(invalid_params)
        }.to raise_error(ShipmentAddressErrors::ShipmentAddressCreationError)
      end
    end
  end

  describe '.update_address' do
    let!(:address) { create(:shipment_address) }

    context 'with valid parameters' do
      it 'updates the address' do
        new_city = "New City"
        updated_address = ShipmentAddressService.update_address(address.id, full_name: "Jane Doe", city: new_city)
        expect(updated_address).to be_persisted
        expect(updated_address.city).to eq(new_city)
      end
    end

    context 'with invalid parameters' do
      it 'raises a ShipmentAddressUpdateError' do
        expect {
          ShipmentAddressService.update_address(address.id, invalid_params)
        }.to raise_error(ShipmentAddressErrors::ShipmentAddressUpdateError)
      end
    end

    context 'when the address does not exist' do
      it 'raises ShipmentAddressNotFoundError' do
        expect {
          ShipmentAddressService.update_address(9999, full_name: "Jane Doe")
        }.to raise_error(ShipmentAddressErrors::ShipmentAddressNotFoundError)
      end
    end
  end

  describe '.delete_address' do
    let!(:address) { create(:shipment_address) }

    it 'deletes the address' do
      expect {
        ShipmentAddressService.delete_address(address.id)
      }.to change { ShipmentAddress.count }.by(-1)
    end

    context 'when the address does not exist' do
      it 'raises ShipmentAddressNotFoundError' do
        expect {
          ShipmentAddressService.delete_address(9999)
        }.to raise_error(ShipmentAddressErrors::ShipmentAddressNotFoundError)
      end
    end

    context 'when deletion fails' do
      it 'raises ShipmentAddressDeletionError' do
        allow_any_instance_of(ShipmentAddress).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
        expect {
          ShipmentAddressService.delete_address(address.id)
        }.to raise_error(ShipmentAddressErrors::ShipmentAddressDeletionError)
      end
    end
  end

  describe '.get_address_by_id' do
    context 'when address exists' do
      let!(:address) { create(:shipment_address) }

      it 'returns the address' do
        fetched_address = ShipmentAddressService.get_address_by_id(address.id)
        expect(fetched_address).to eq(address)
      end
    end

    context 'when address does not exist' do
      it 'raises ShipmentAddressNotFoundError' do
        expect {
          ShipmentAddressService.get_address_by_id(9999)
        }.to raise_error(ShipmentAddressErrors::ShipmentAddressNotFoundError)
      end
    end
  end
end
