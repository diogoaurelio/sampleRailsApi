class ChangeColumnsProduct < ActiveRecord::Migration
  def change
    remove_column :products, :title
    remove_column :products, :price
    remove_column :products, :published
    add_column :products, :title, :string, default: ""
    add_column :products, :price, :decimal, default: "0.0"
    add_column :products, :published, :boolean, default: false
  end
end
