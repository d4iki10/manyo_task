class CreateLabels < ActiveRecord::Migration[6.1]
  def change
    unless table_exists?(:labels)
      create_table :labels do |t|
        t.string :name, null: false
        t.references :user, null: false, foreign_key: true

        t.timestamps
      end
    end
  end
end
