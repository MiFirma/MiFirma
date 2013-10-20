class CreateFeedbackSignatures < ActiveRecord::Migration
  def self.up
    create_table :feedback_signatures do |t|
      t.references :reason_feedback
      t.references :signature
      t.references :proposal

      t.timestamps
    end
  end

  def self.down
    drop_table :feedback_signatures
  end
end
