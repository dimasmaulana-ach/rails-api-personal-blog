class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :username, :email, :role, :avatar

  def avatar
    Rails.application.routes.default_url_options[:host] = "http://localhost:3000#{avatar_url}"
  end

  def avatar_url
    if object.avatar.attached?
      rails_blob_path(object.avatar, only_path: true, host: "http://localhost:3000")
    else
      nil
    end
  end
end
