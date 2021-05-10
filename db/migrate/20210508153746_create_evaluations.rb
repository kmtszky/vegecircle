class CreateEvaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluations do |t|

      t.references :customer, null: false, foreign_key: true
      t.references :farmer,   null: false, foreign_key: true
      t.float :evaluation,    default: 0
      t.timestamps
    end
  end
end
