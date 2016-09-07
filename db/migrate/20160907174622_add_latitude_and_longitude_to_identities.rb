class AddLatitudeAndLongitudeToIdentities < ActiveRecord::Migration[5.0]
  def change
    add_column :identities, :latitude, :float
    add_column :identities, :longitude, :float
  end
end
