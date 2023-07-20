class User < ApplicationRecord
    has_secure_password
    has_one_attached :avatar

    before_save :rename_avatar, :custom_blob_key
    
    has_many :blogs, class_name: "Blog", foreign_key: :user_id, dependent: :restrict_with_error
    belongs_to :role, class_name: "Role", foreign_key: :role_id #, dependent: :restrict_with_error

    validates :username, uniqueness: {message: "username already in use"}
    validates :username, presence: true, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only contain letters, numbers, and underscores (_) without spaces" }

    validates :email, uniqueness: {message: "email already in use"}
    validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: "invalid e-mail format" }

    def avatar_url
      return unless avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(avatar)
    end

    def custom_blob_key
      key = "avatars/#{avatar.filename}"
      avatar.blob.update(key: key)
    end

    def rename_avatar
      if avatar.attached?
        extension = File.extname(avatar.filename.to_s)
        new_filename = "#{SecureRandom.uuid}#{extension}"
        avatar.blob.update(filename: new_filename)
      end
    end

    private
  
    def purge_avatar_and_directory
      if avatar.attached?
        avatar.purge
        FileUtils.rm_rf(Rails.root.join('storage', 'path', 'to', 'directory', 'associated', 'with', 'avatar'))
      end
    end

end
