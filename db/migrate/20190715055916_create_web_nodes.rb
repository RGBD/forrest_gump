class CreateWebNodes < ActiveRecord::Migration[5.2]
  def change
    create_table :web_nodes do |t|
      t.string :name, null: false
      t.string :path
      t.belongs_to :parent, foreign_key: { to_table: :web_nodes }

      t.timestamps
    end
  end
end
