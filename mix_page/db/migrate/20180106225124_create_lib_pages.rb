class CreateLibPages < ActiveRecord::Migration[6.0]
  def change
    create_table :lib_pages do |t|
      # TODO changes (logidze)
      # TODO cache
      # admin scopes (page_id IS NULL, page_id = p0, page_id = p1, etc. or templates)
      t.uuid       :uuid,                null: false, default: 'uuid_generate_v1mc()', index: { using: :hash }
      t.belongs_to :page_layout,         foreign_key: { to_table: :lib_pages }
      t.belongs_to :page_template,       foreign_key: { to_table: :lib_pages }

      t.integer    :view,                null: false
      t.float      :position,            null: false, limit: 53, default: 0.0

      t.integer    :pages_count,         null: false, default: 0
      t.integer    :page_sections_count, null: false, default: 0
      t.integer    :page_fields_count,   null: false, default: 0

      t.integer    :type,                null: false
      t.jsonb      :json_data,           null: false, default: {}
      t.integer    :lock_version,        null: false, default: 0
      t.userstamps
      t.timestamps
      t.datetime   :deleted_at
      t.datetime   :published_at
    end

    add_index :lib_pages, [:page_layout_id, :page_template_id, :position],
      name: 'index_lib_pages_on_page_layout_id_page_template_id_position', unique: true
  end
end