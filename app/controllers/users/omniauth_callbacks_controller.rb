class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def github
		# You need to implement the method below in your model (e.g. app/models/user.rb)
	    @user = User.find_for_github_oauth(request.env["omniauth.auth"])

	    if @user.persisted?
	      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
	      set_flash_message(:notice, :success, :kind => "GitHub") if is_navigational_format?
	    else
	      session["devise.github_data"] = request.env["omniauth.auth"]
	      set_flash_message(:notice, :not_whitelisted, :kind => "GitHub" )
	      redirect_to new_user_session_url
	    end
	end
end