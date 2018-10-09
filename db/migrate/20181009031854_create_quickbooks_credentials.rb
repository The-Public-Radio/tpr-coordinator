class CreateQuickbooksCredentials < ActiveRecord::Migration[5.1]
  def change
    create_table :quickbooks_credentials do |t|
      t.string :access_token, limit: 1024, null: false
      t.string :refresh_token, null: false
      t.string :realm_id, null: false

      t.timestamps
    end
  end
end
