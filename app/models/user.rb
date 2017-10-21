class User < Sequel::Model
  plugin :secure_password

  def gravatar_url
    "//www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?default=404"
  end
end