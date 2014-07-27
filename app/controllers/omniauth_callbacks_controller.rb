class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	# method to handle all omniauth callbacks.
	def all
		user = User.from_omniauth(env["omniauth.auth"], current_user)
		if user.persisted?
			sign_in user
			flash[:notice] = t('devise.omniauth_callbacks.success', :kind => User::SOCIALS[params[:action].to_sym])
			if user.sign_in_count ==1
				redirect_to root_path
			else
				redirect_to root_path
			end
		else
			session['devise.user_attributes'] = user.user_attributes
			redirect_to new_user_registration_url
		end
	end

	# alias method to redirect each Oauth provider to the "all" method.
	# Uses the SOCIALS constant from the User model, so add one every time you add a provider.
	User::SOCIALS.each do |k, _|
		alias_method k, :all
	end
end
