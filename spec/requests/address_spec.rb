require 'rails_helper'

RSpec.describe AddressService, type: :service do
  let(:user) { create(:user) }
  let(:valid_params) do
    {
      full_name: "John Doe",
      phone_number: "1234567890",
      address_line1: "123 Street",
      city: "Cityville",
      state: "Stateville",
      zip_code: "12345",
      country: "Countryland"
    }
  end

  describe '.add_address' do
    context 'with valid params' do
      it 'creates a new address' do
        address = AddressService.add_address(user.id, valid_params)
        expect(address).to be_persisted
        expect(address.full_name).to eq("John Doe")
      end
    end

    context 'with missing required fields' do
      it 'raises MissingParameterError' do
        expect {
          AddressService.add_address(user.id, {})
        }.to raise_error(AddressErrors::MissingParameterError)
      end
    end
  end

  describe '.update_address' do
    let!(:address) { create(:address, user: user, full_name: "Old Name") }

    it 'updates the address' do
      updated = AddressService.update_address(address.id, { full_name: "New Name" })
      expect(updated.full_name).to eq("New Name")
    end

    it 'raises AddressNotFoundError for invalid ID' do
      expect {
        AddressService.update_address(0, { full_name: "X" })
      }.to raise_error(AddressErrors::AddressNotFoundError)
    end
  end

  describe '.delete_address' do
    let!(:address) { create(:address, user: user) }

    it 'deletes the address' do
      expect {
        AddressService.delete_address(user.id, address.id)
      }.to change { Address.count }.by(-1)
    end

    it 'raises UnauthorizedAccessError for wrong user' do
      other_user = create(:user)
      expect {
        AddressService.delete_address(other_user.id, address.id)
      }.to raise_error(AddressErrors::UnauthorizedAccessError)
    end
  end

  describe '.get_address' do
    let!(:address) { create(:address, user: user) }

    it 'returns the address if found' do
      result = AddressService.get_address(address.id)
      expect(result).to eq(address)
    end

    it 'raises AddressNotFoundError if not found' do
      expect {
        AddressService.get_address(0)
      }.to raise_error(AddressErrors::AddressNotFoundError)
    end
  end

  describe '.get_all_addresses' do
    it 'returns all addresses for the user' do
      create_list(:address, 2, user: user)
      result = AddressService.get_all_addresses(user.id)
      expect(result.count).to eq(2)
    end

    it 'raises AddressNotFoundError if none exist' do
      expect {
        AddressService.get_all_addresses(user.id)
      }.to raise_error(AddressErrors::AddressNotFoundError)
    end
  end
end
