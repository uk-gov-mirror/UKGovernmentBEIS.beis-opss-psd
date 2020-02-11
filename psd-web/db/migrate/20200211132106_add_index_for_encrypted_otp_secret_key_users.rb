class AddIndexForEncryptedOtpSecretKeyUsers < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :users, :encrypted_otp_secret_key, unique: true, algorithm: :concurrently
  end
end
