class AddUidColumnToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :document_uid, :string
    add_index :documents, :document_uid, unique: true
  end
end
