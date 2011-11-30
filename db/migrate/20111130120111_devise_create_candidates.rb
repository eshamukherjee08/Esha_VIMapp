class DeviseCreateCandidates < ActiveRecord::Migration
  def self.up
    create_table(:candidates) do |t|
      t.database_authenticatable :null => false
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :candidates, :email,                :unique => true
    add_index :candidates, :reset_password_token, :unique => true
    # add_index :candidates, :confirmation_token,   :unique => true
    # add_index :candidates, :unlock_token,         :unique => true
    # add_index :candidates, :authentication_token, :unique => true
  end

  def self.down
    drop_table :candidates
  end
end
