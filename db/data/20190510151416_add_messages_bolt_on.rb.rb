class AddMessagesBoltOn < ActiveRecord::Migration[5.2]
  def up
    BoltOn.create!(name: 'AssetsMessages')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
