class AddCountryCodeToRadioModel < ActiveRecord::Migration[5.1]
  def change
  	add_column :radios, :country_code, :string
  end
end
