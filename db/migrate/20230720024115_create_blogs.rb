class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs, id: :uuid do |t|
      t.string :title
      t.string :slug
      t.text :body
      t.references :user, type: :uuid, foreign_key: true
      t.references :blog_category, type: :uuid, foreign_key: true

      t.timestamps
    end
    add_index :blogs, :title, :unique => true
    add_index :blogs, :slug, :unique => true
  end
end
