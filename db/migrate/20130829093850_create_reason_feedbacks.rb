class CreateReasonFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :reason_feedbacks do |t|
      t.text :reason

      t.timestamps
    end
  end

  def self.down
    drop_table :reason_feedbacks
  end
end
