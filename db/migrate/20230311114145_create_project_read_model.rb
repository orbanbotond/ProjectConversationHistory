class CreateProjectReadModel < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :project_read_models, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :title
      t.string :status

      t.timestamps
    end
  end
end
