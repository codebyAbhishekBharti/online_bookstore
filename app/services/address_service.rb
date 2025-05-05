class AddressService
  def self.add_address(user_id, params)
    required_fields = %i[full_name phone_number address_line1 city state zip_code country]
    missing_fields = required_fields.select { |field| params[field].blank? }
    unless missing_fields.empty?
      raise AddressErrors::MissingParameterError, "Missing parameters: #{missing_fields.join(', ')}"
    end

    address = Address.create!(
      user_id: user_id,
      full_name: params[:full_name],
      phone_number: params[:phone_number],
      address_line1: params[:address_line1],
      address_line2: params[:address_line2],
      city: params[:city],
      state: params[:state],
      zip_code: params[:zip_code],
      country: params[:country],
      is_default: params[:is_default],
      address_type: params[:address_type]
    )
    address
  rescue ActiveRecord::RecordNotUnique => e
    raise AddressErrors::AddressOperationFailedError, "Address already exists"
  rescue ActiveRecord::RecordInvalid => e
    raise AddressErrors::AddressOperationFailedError
  end

  def self.update_address(address_id, params)
    address = Address.find_by(id: address_id)
    raise AddressErrors::AddressNotFoundError unless address

    allowed_params = %i[full_name phone_number address_line1 address_line2 city state zip_code country is_default address_type]
    filtered_params = params.slice(*allowed_params)

    address.update!(filtered_params)
    address
  rescue ActiveRecord::RecordInvalid => e
    raise AddressErrors::AddressOperationFailedError, e.message
  end

  def self.delete_address(user_id, address_id)
    address = self.get_address(address_id)
    raise AddressErrors::UnauthorizedAccessError unless address.user_id == user_id

    address.destroy
  rescue => e
    raise AddressErrors::AddressOperationFailedError, e.message
  end

  def self.get_address(address_id)
    address = Address.find_by(id: address_id)
    raise AddressErrors::AddressNotFoundError unless address

    address
  end

  def self.get_all_addresses(user_id)
    addresses = Address.where(user_id: user_id)
    raise AddressErrors::AddressNotFoundError, "No addresses found" if addresses.empty?

    addresses
  end
end
