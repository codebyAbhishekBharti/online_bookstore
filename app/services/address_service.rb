class AddressService
  def self.add_address(user_id, params)
    # user_id = params[:user_id]
    full_name = params[:full_name]
    phone_number = params[:phone_number]
    address_line1 = params[:address_line1]
    address_line2 = params[:address_line2]
    city = params[:city]
    state = params[:state]
    zip_code = params[:zip_code]
    country = params[:country]
    is_default = params[:is_default]
    address_type = params[:address_type]
    raise "Full name, phone number, address line 1, city, state, zip code, and country are required" unless full_name && phone_number && address_line1 && city && state && zip_code && country

    address = Address.create!(
      user_id:  user_id,
      full_name: full_name,
      phone_number: phone_number,
      address_line1: address_line1,
      address_line2: address_line2,
      city: city,
      state: state,
      zip_code: zip_code,
      country: country,
      is_default: is_default,
      address_type: address_type
    )
  end

  def self.update_address(address_id, params)
    address = Address.find_by(id: address_id)
    raise "Address not found" unless address

    allowed_params = [ :full_name, :phone_number, :address_line1, :address_line2, :city, :state, :zip_code, :country, :is_default, :address_type ]
    filtered_params = params.slice(*allowed_params)

    address.update!(filtered_params)
    address  # Return updated user object
  end

  def self.delete_address(user_id,address_id)
    # Find the cart item
    address = Address.find_by(id: address_id)
    if address.nil?
      raise "address not found"
    end
    if address.user_id != user_id
      raise "User is not authorized to delete this address"
    end
    # Find the cart item
    address = Address.find_by(id: address_id, user_id: user_id)
    raise "address not found" unless address
    # Delete the cart item
    address.destroy
  end

  def self.get_address(address_id)
    Address.find_by(id: address_id)
  end

  def self.get_all_addresses(user_id)
    Address.where(user_id: user_id)
  end
end
