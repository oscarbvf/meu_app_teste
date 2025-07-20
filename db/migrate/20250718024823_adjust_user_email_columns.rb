class AdjustUserEmailColumns < ActiveRecord::Migration[8.0]
  def change
    # Removes empty column created by Devise
    remove_column :users, :email, :string

    # Rename the old email_address column for Devise purposes
    rename_column :users, :email_address, :email
  end
end
