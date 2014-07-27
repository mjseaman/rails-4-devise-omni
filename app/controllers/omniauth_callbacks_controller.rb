class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	# method to handle all omniauth callbacks.
	def all
		user = User.from_omniauth(request.env["omniauth.auth"])
	end

	# alias method to redirect each Oauth provider to the "all" method
	alias_method :foursquare, :all

end
