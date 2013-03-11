class AuthenticationController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]

    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
      # Authentication not found, thus a new user.
      email=auth['info']['email']
      check_user=User.find_by_email(email)

      if check_user
        flash[:error] = "Email id #{email} Already Registered using #{check_user.provider.capitalize}"
        redirect_to root_url
      else
        user = User.new
        user.apply_omniauth(auth)
        if user.save(:validate => false)
          flash[:notice] = "Account created and signed in successfully."
          sign_in_and_redirect(:user, user)
        
        else
          flash[:error] = "Error while creating a user account. Please try again."
          redirect_to root_url
        end
      end
    end
 
end
