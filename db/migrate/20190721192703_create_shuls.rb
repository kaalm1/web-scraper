class CreateShuls < ActiveRecord::Migration[5.2]
  def change
    create_table :shuls do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :website
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country

      t.timestamps
    end
  end
end
