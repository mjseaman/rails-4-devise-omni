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
  	authorization = Authorization.where(:provider => auth.provider,
  																		 :token    => auth.uid.to_s,
  																		 :token    => auth.credentials.token,
  																		 :secret   => auth.credentials.secret).first_or_initialize
  	ap auth
  	# authorization.profile_page = auth.info.urls.first.last unless authorization.persisted?
  	if authorization.user.blank?
  		user = current_user.nil? ? User.where('email = ?', auth['info']['email']).first : current_user
  		if user.blank?
	  		user = User.new
	  		# user.skip_confirmation! #add this back if we make users confirmable
	  		user.password = Devise.friendly_token[0,20]
	  		user.fetch_details(auth)
	  		user.save
	  	end
	  	authorization.user = user
	  	authorization.save
  	end
  	authorization.user
  end

  def fetch_details(auth)
  	self.name = auth.info.name
  	self.email = auth.info.email
  	if auth.provider = "foursquare"
  		self.photo = auth.info.image.prefix + "500x500" + auth.info.image.suffix
  	else
  		self.photo = URI.parse(auth.info.image)
  	end
  end

end
