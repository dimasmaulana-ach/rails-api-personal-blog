class Role < ApplicationRecord

    has_many :users, class_name: "User", foreign_key: :role_id, dependent: :restrict_with_error

end
