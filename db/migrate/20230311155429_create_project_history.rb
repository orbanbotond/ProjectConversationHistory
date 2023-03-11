class CreateProjectHistory < ActiveRecord::Migration[7.0]
  def change
    create_table :project_histories do |t|
      t.string :project_id
      t.string :action
      t.datetime :created_at, null: false
    end
  end
end
