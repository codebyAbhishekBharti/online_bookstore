# app/services/shipment_address_service.rb
class ShipmentAddressService
  def self.get_all_addresses
    ShipmentAddress.all
  end

  def self.create_address(params)
    begin
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
      address
    rescue ActiveRecord::RecordInvalid => e
      raise ShipmentAddressErrors::ShipmentAddressCreationError, e.message
    end
  end

  def self.update_address(id, params)
    address = self.get_address_by_id(id)

    allowed_params = [ :full_name, :phone_number, :address_line1, :address_line2, :city, :state, :zip_code, :country, :address_type ]
    filtered_params = params.slice(*allowed_params)

    begin
      address.update!(filtered_params)
      address
    rescue ActiveRecord::RecordInvalid => e
      raise ShipmentAddressErrors::ShipmentAddressUpdateError, e.message
    end
  end

  def self.delete_address(id)
    address = self.get_address_by_id(id)
    begin
      address.destroy!
    rescue ActiveRecord::RecordNotDestroyed => e
      raise ShipmentAddressErrors::ShipmentAddressDeletionError, e.message
    end
  end

  def self.get_address_by_id(id)
    address = ShipmentAddress.find_by(id: id)
    raise ShipmentAddressErrors::ShipmentAddressNotFoundError, "Shipment address not found" unless address
    address
  end
end
