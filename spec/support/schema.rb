ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string    :name
    t.string    :login
    t.string    :email
    t.boolean   :enabled
    t.timestamps
  end

  create_table :posts, force: true do |t|
    t.string    :title
    t.string    :message
    t.integer   :user_id
    t.integer   :topic_id
    t.boolean   :enabled
    t.timestamps
  end

  create_table :forums, force: true do |t|
    t.string    :title
    t.string    :description
    t.integer   :user_id
    t.timestamps
  end

  create_table :topics, force: true do |t|
    t.string    :title
    t.string    :message
    t.integer   :user_id
    t.integer   :forum_id
    t.timestamps
  end

end