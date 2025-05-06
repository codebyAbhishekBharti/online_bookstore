# spec/services/shipment_address_service_spec.rb
require 'rails_helper'

RSpec.describe ShipmentAddressService, type: :service do
  let(:user) { create(:user) }
  let(:valid_address_params) do
    {
      full_name: "John Doe",
      phone_number: "1234567890",
      address_line1: "123 Main St",
      city: "City",
      state: "State",
      zip_code: "12345",
      country: "Country"
    }
  end
  let(:address) { create(:shipment_address, user: user) }

  describe '.create_address' do
    it 'creates a new address successfully' do
      expect {
        ShipmentAddressService.create_address(valid_address_params)
      }.to change { ShipmentAddress.count }.by(1)
    end

    it 'raises an error when invalid params are provided' do
      expect {
        ShipmentAddressService.create_address(full_name: "")
      }.to raise_error(ShipmentAddressErrors::ShipmentAddressCreationError)
    end
  end

  describe '.get_all_addresses' do
    it 'returns all addresses' do
      create(:shipment_address, user: user)
      addresses = ShipmentAddressService.get_all_addresses

      expect(addresses.count).to eq(1)
      expect(addresses.first.full_name).to eq(user.shipment_addresses.first.full_name)
    end
  end

  describe '.get_address_by_id' do
    it 'returns a shipment address by ID' do
      address = create(:shipment_address, user: user)
      result = ShipmentAddressService.get_address_by_id(address.id)

      expect(result).to eq(address)
    end

    it 'raises an error if the address is not found' do
      expect {
        ShipmentAddressService.get_address_by_id(9999)
      }.to raise_error(ShipmentAddressErrors::ShipmentAddressNotFoundError)
    end
  end

  describe '.update_address' do
    it 'updates the address successfully' do
      updated_params = { full_name: "Updated Name" }
      updated_address = ShipmentAddressService.update_address(address.id, updated_params)

      expect(updated_address.full_name).to eq("Updated Name")
    end

    it 'raises an error if the address update fails' do
      expect {
        ShipmentAddressService.update_address(address.id, { full_name: "" })
      }.to raise_error(ShipmentAddressErrors::ShipmentAddressUpdateError)
    end
  end

  describe '.delete_address' do
    it 'deletes the address successfully' do
      address = create(:shipment_address, user: user)
      expect {
        ShipmentAddressService.delete_address(address.id)
      }.to change { ShipmentAddress.count }.by(-1)
    end

    it 'raises an error if the address deletion fails' do
      expect {
        ShipmentAddressService.delete_address(9999)
      }.to raise_error(ShipmentAddressErrors::ShipmentAddressDeletionError)
    end
  end
end
