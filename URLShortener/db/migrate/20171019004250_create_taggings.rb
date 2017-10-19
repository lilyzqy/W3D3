class CreateTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :taggings do |t|
      t.integer :topic_id, null: false
      t.integer :shortened_url_id, null: false
      t.timestamps
    end

    # add_index :topic_id,:shortened_url_id
  end
end
