# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://guides.hanamirb.org/v2.2/database/migrations/ for details.
  change do
    create_table :users do
      primary_key :id

      column :name, String, null: false
      column :username, String, null: false, unique: true
      column :email_address, String, null: false, unique: true
      column :password_hash, String, null: false
      column :bio, :text, null: true

      column :created_at, :timestamp, null: false, default: Sequel.lit("CURRENT_TIMESTAMP")
      column :updated_at, :timestamp, null: false, default: Sequel.lit("CURRENT_TIMESTAMP")
    end
  end
end
