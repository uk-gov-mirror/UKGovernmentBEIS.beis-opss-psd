class TwoFactorAuthenticationAddToUsers < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/BulkChangeTable
  def change
    add_column :users, :second_factor_attempts_count, :integer
    add_column :users, :encrypted_otp_secret_key, :string
    add_column :users, :encrypted_otp_secret_key_iv, :string
    add_column :users, :encrypted_otp_secret_key_salt, :string
    add_column :users, :direct_otp, :string
    add_column :users, :direct_otp_sent_at, :datetime
    add_column :users, :totp_timestamp, :timestamp

    change_column_default :users, :second_factor_attempts_count, from: nil, to: 0
  end
  # rubocop:enable Rails/BulkChangeTable
end
