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

  default_scope order('forums.description')
end

class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum

  default_scope order('topics.title')
end