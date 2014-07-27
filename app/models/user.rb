class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable
  
  SOCIALS = {
  	foursquare: "Foursquare"
  }

  has_many :authorizations

  def self.from_omniauth(auth, current_user)
  	authorization = Authorization.where(:provider => auth.provider
  																		 ,:token    => auth.uid.to_s
  																		 ,:token    => auth.credentials.token
  																		 ,:secret   => auth.credentials.secret).first_or_initialize
  	authorization.profile_page = auth.info.urls.first.last unless authorization.persisted?
  	if authorization.user.blank?
  		user = User.new
  		user.skip_confirmation!
  		user.password = Devise.friendly_token[0,20]
  		user.fetch_details(auth)
  		user.save
  	end
  end

end
