class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.integer :difficulty
      t.text :statement
      t.text :sample_input
      t.text :sample_output
      t.integer :region_id

      t.timestamps
    end
  end
end
