# app/services/shipment_address_service.rb
class ShipmentAddressService
  def self.get_all_addresses()
    ShipmentAddress.all
  end
  def self.create_address(params)
    address = ShipmentAddress.create!(
      full_name: params[:full_name],
      phone_number: params[:phone_number],
      address_line1: params[:address_line1],
      address_line2: params[:address_line2],
      city: params[:city],
      state: params[:state],
      zip_code: params[:zip_code],
      country: params[:country],
      address_type: params[:address_type],
    )
  end

  def self.update_address(id, params)
    address = ShipmentAddress.find_by(id: id)
    raise "Address not found" unless address

    allowed_params = [ :full_name, :phone_number, :address_line1, :address_line2, :city, :state, :zip_code, :country, :address_type ]
    filtered_params = params.slice(*allowed_params)

    address.update!(filtered_params)
    address  # Return updated user object
  end

  def self.delete_address(id)
    # Find the cart item
    address =  ShipmentAddress.find_by(id: id)
    if address.nil?
      raise "address not found"
    end
    # Delete the cart item
    address.destroy
  end
end