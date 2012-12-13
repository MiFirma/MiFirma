ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do

  create_table :admin_users, :force => true do |t|
    t.string :first_name
    t.string :last_name
    t.string :role, :null => false
    t.string :email, :null => false
    t.string :password_digest, :null => false
    t.string :preferences
    t.boolean :status, :default => false
    t.timestamps
  end

  create_table :articles, :force => true do |t|
    t.string :title
    t.text :body
    t.timestamps
  end

  create_table :assets, :force => true do |t|
    t.string :caption
    # Dragonfly Attachment
    t.string :dragonfly_uid
    t.string :dragonfly_required_uid
    # Paperclip Attachment
    t.string :paperclip_file_name
    t.string :paperclip_content_type
    t.integer :paperclip_file_size
    t.datetime :paperclip_updated_at
  end

  create_table :categories, :force => true do |t|
    t.string :name
    t.string :permalink
    t.text :description
    t.integer :position
  end

  create_table :comments, :force => true do |t|
    t.string :email, :name
    t.text :body
    t.integer :post_id
    t.boolean :spam, :default => false
  end

  add_index :comments, :post_id

  create_table :delayed_tasks, :force => true do |t|
    t.string :name
  end

  create_table :entries, :force => true do |t|
    t.string :title, :null => false
    t.text :content
    t.string :type
    t.boolean :published, :null => false, :default => false
  end

  create_table :categories_entries, :force => true, :id => false do |t|
    t.column :category_id, :integer
    t.column :entry_id, :integer
  end

  create_table :pages, :force => true do |t|
    t.string :title
    t.text :body
    t.boolean :status
    t.integer :parent_id
  end

  add_index :pages, :parent_id

  create_table :posts, :force => true do |t|
    t.string :title
    t.text :body
    t.string :status
    t.integer :favorite_comment_id
    t.datetime :published_at
    t.integer :typus_user_id
    t.boolean :published
    t.timestamps
  end

  add_index :posts, :favorite_comment_id
  add_index :posts, :typus_user_id

  create_table :pictures, :force => true do |t|
    t.string :title
    t.string :picture_file_name
    t.string :picture_content_type
    t.integer :picture_file_size
    t.datetime :picture_updated_at
    t.integer :typus_user_id
    t.timestamps
  end

  add_index :pictures, :typus_user_id

  create_table :typus_users, :force => true do |t|
    t.string :first_name, :default => "", :null => false
    t.string :last_name, :default => "", :null => false
    t.string :role, :null => false
    t.string :email, :null => false
    t.boolean :status, :default => false
    t.string :token, :null => false
    t.string :salt, :null => false
    t.string :crypted_password, :null => false
    t.string :preferences
    t.timestamps
  end

  add_index :typus_users, :token

  create_table :views, :force => true do |t|
    t.string :ip, :default => '127.0.0.1'
    t.integer :post_id
    t.timestamps
  end

  add_index :views, :post_id

  create_table :categories_posts, :force => true, :id => false do |t|
    t.column :category_id, :integer
    t.column :post_id, :integer
  end

  add_index :categories_posts, :category_id
  add_index :categories_posts, :post_id

  ##
  # has_one relationships
  #

  create_table :invoices, :force => true do |t|
    t.string :number
    t.integer :order_id
    t.integer :typus_user_id
    t.timestamps
  end

  create_table :orders, :force => true do |t|
    t.string :number
    t.timestamps
  end

  ##
  # has_many through relationships
  #

  create_table :users, :force => true do |t|
    t.string :name, :null => false
    t.string :email
    t.timestamps
  end

  create_table :projects, :force => true do |t|
    t.string :name, :null => false
    t.integer :user_id, :null => false
    t.timestamps
  end

  create_table :project_collaborators, :force => true do |t|
    t.integer :user_id, :null => false
    t.integer :project_id, :null => false
    t.timestamps
  end

  ##
  # Polymorphic
  #

  create_table :animals, :force => true do |t|
    t.string :name, :null => false
    t.string :type
  end

  create_table :image_holders, :force => true do |t|
    t.string :name
    t.integer :imageable_id
    t.string :imageable_type
  end

end
