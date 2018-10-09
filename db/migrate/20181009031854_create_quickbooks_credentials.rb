class CreateQuickbooksCredentials < ActiveRecord::Migration[5.1]
  def change
    create_table :quickbooks_credentials do |t|
      t.string :access_token, limit: 1024
      t.string :refresh_token
      t.string :realm_id

      t.timestamps
    end
  end
end
