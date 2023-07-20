class BlogSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :slug, :body, :image, :user, :blog_category
  has_one :user

  def image
    Rails.application.routes.default_url_options[:host] = "http://localhost:3000#{image_url}"
  end

  def image_url
    if object.image.attached?
      rails_blob_path(object.image, only_path: true, host: "http://localhost:3000")
    else
      nil
    end
  end
end
