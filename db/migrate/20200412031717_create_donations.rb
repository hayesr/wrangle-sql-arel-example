class CreateDonations < ActiveRecord::Migration[6.0]
  def change
    create_table :donations do |t|
      t.belongs_to :donor, null: false, foreign_key: true
      t.float :amount
      t.date :entered_on

      t.timestamps
    end
  end
end
