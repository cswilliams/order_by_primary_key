class User < ActiveRecord::Base
  has_many :posts

  scope :name_sort, order(:name)
end

class Post < ActiveRecord::Base
  belongs_to :user

  default_scope order(:title)
end

class Forum < ActiveRecord::Base
  belongs_to :user
  has_many :topics
  has_many :posts, through: :topics
  has_many :enabled_posts, class_name: 'Post', foreign_key: 'post_id', through: :topics, source: :posts, conditions: { enabled: true }

  default_scope order('forums.description')
end

class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum

  has_many :posts

  default_scope order('topics.title')
end