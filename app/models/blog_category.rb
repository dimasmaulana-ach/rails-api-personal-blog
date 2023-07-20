class BlogCategory < ApplicationRecord

    has_many :blogs, class_name: "Blog", foreign_key: :blog_category_id, dependent: :restrict_with_error

end
