class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.integer :problem_id
      t.text :code
      t.text :input
      t.text :expected_output
      t.text :output
      t.boolean :success
      t.timestamp :timestamp

      t.timestamps
    end
  end
end
