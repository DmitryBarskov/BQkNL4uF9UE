class CreateFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :feedbacks do |t|
      t.integer :quality
      t.string :age_group
      t.integer :nps
      t.string :status
      t.references :branch, null: false, foreign_key: true
      t.datetime :experiences_at

      t.timestamps
    end
  end
end
