class CreateRadios < ActiveRecord::Migration[5.1]
  def change
    create_table :radios do |t|
      t.string :frequency

      t.timestamps
    end
  end
end
