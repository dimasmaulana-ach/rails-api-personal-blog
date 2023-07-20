class Blog < ApplicationRecord

    has_one_attached :image

    validates :title, uniqueness: {message: "please with another title"}
    belongs_to :blog_category, class_name: "BlogCategory", foreign_key: :blog_category_id
    belongs_to :user, class_name: "User", foreign_key: :user_id

    before_save :rename_image, :custom_blob_key

    def custom_blob_key
        key = "blogs/#{image.filename}"
        image.blob.update(key: key)
    end

    def rename_image
        if image.attached?
            extension = File.extname(image.filename.to_s)
            new_filename = "#{SecureRandom.uuid}#{extension}"
            image.blob.update(filename: new_filename)
        end
    end

end
