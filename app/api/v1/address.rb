
module V1
  class Address < Grape::API
    helpers AuthHelper

    resource :address do
      before do
        authenticate_user!
      end

      desc "Add address for the user"
      params do
        requires :full_name, type: String, desc: "Full name of the user"
        requires :phone_number, type: String, desc: "Phone number of the user"
        requires :address_line1, type: String, desc: "Address line 1"
        optional :address_line2, type: String, desc: "Address line 2"
        requires :city, type: String, desc: "City"
        requires :state, type: String, desc: "State"
        requires :zip_code, type: String, desc: "Zip code"
        requires :country, type: String, desc: "Country"
        optional :is_default, type: Boolean, desc: "Is this the default address?"
        optional :address_type, type: String, desc: "Type of address (e.g., home, work)"
      end
      post do
        response = AddressService.add_address(current_user.id, params)
        present :status, :success
        present :data, response
      end

      desc "get all addresses for the user"
      get do
        response = AddressService.get_all_addresses(current_user.id)
        present :status, :success
        present :data, response
      end

      desc "Update address details"
      params do
        requires :id, type: Integer, desc: "Address ID"
        optional :full_name, type: String, desc: "Full name of the user"
        optional :phone_number, type: String, desc: "Phone number of the user"
        optional :address_line1, type: String, desc: "Address line 1"
        optional :address_line2, type: String, desc: "Address line 2"
        optional :city, type: String, desc: "City"
        optional :state, type: String, desc: "State"
        optional :zip_code, type: String, desc: "Zip code"
        optional :country, type: String, desc: "Country"
        optional :is_default, type: Boolean, desc: "Is this the default address?"
        optional :address_type, type: String, desc: "Type of address (e.g., home, work)"
      end
      patch do
        response = AddressService.update_address(params[:id], params)
        present :status, :success
        present :data, response
      end

      desc "delete the address"
      params do
        requires :id, type: Integer, desc: "Address ID"
      end
      delete do
        response = AddressService.delete_address(current_user.id,params[:id])
        present :status, :success
        present :data, response
      end
    end
  end
end