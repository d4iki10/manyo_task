class CreateLabelings < ActiveRecord::Migration[6.1]
  def change
    unless table_exists?(:labelings)
      create_table :labelings do |t|
        t.references :task, null: false, foreign_key: true
        t.references :label, null: false, foreign_key: true

        t.timestamps
      end
      add_index :labelings, [:task_id, :label_id], unique: true
    end
  end
end
