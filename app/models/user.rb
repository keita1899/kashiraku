class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :materials, dependent: :destroy

  def self.from_omniauth(auth)
    create_or_find_by!(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.name = auth.info.name
    end.tap do |user|
      user.update!(
        email: auth.info.email,
        name: auth.info.name
      )
    end
  end

  def self.guest
    uid = "guest_#{SecureRandom.uuid}"
    create!(provider: "guest", uid: uid, email: "#{uid}@example.com", name: "ゲスト")
  end

  def display_name
    name.presence || email
  end

  def guest?
    provider == "guest"
  end
end
