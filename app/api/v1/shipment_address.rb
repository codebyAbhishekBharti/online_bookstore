module V1
  class ShipmentAddress < Grape::API
    helpers AuthHelper

    
    resource :shipment_address do
      before do
        authenticate_user!
      end

      desc 'Get shipment address'
      get do
        response = ShipmentAddressService.get_all_addresses
        present :status, :success
        present :data, response
      end

      desc "Get shipment address by ID"
      params do
        requires :id, type: Integer, desc: "Shipment address ID"
      end
      get ':id' do
        response = ShipmentAddressService.get_address_by_id(params[:id])
        present :status, :success
        present :data, response
      end

      desc 'Create shipment address'
      params do
        requires :full_name, type: String, desc: "Full name of the user"
        requires :phone_number, type: String, desc: "Phone number of the user"
        requires :address_line1, type: String, desc: "Address line 1"
        optional :address_line2, type: String, desc: "Address line 2"
        requires :city, type: String, desc: "City"
        requires :state, type: String, desc: "State"
        requires :zip_code, type: String, desc: "Zip code"
        requires :country, type: String, desc: "Country"
        optional :address_type, type: String, desc: "Type of address (e.g., home, work)"
      end
      post do
        response = ShipmentAddressService.create_address(params)
        present :status, :success
        present :data, response
      end

      desc "delete shipment address"
      params do
        requires :id, type: Integer, desc: "Shipment address ID"
      end
      delete ':id' do
        response = ShipmentAddressService.delete_address(params[:id])
        present :status, :success
        present :data, response
      end

      desc 'Update shipment address'
      params do
        requires :id, type: Integer, desc: "Shipment address ID"
        optional :full_name, type: String, desc: "Full name of the user"
        optional :phone_number, type: String, desc: "Phone number of the user"
        optional :address_line1, type: String, desc: "Address line 1"
        optional :address_line2, type: String, desc: "Address line 2"
        optional :city, type: String, desc: "City"
        optional :state, type: String, desc: "State"
        optional :zip_code, type: String, desc: "Zip code"
        optional :country, type: String, desc: "Country"
        optional :address_type, type: String, desc: "Type of address (e.g., home, work)"
      end
      patch do
        response = ShipmentAddressService.update_address(params[:id], params)
        present :status, :success
        present :data, response
      end
    end
  end
end