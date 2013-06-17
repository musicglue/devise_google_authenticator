class Devise::DisplayqrController < DeviseController
  prepend_before_filter :authenticate_scope!, :only => [:show,:update]
  
  def show
    if not resource.nil? and not resource.gauth_secret.nil?
      render :show
    else
      sign_in scope, resource, :bypass => true
      redirect_to stored_location_for(scope) || :root
    end
  end
  
  def update
    if resource.set_gauth_enabled(resource_params)
      set_flash_message :notice, "Status Updated!"
      sign_in scope, resource, :bypass => true
      redirect_to stored_location_for(scope) || :root
    else
      render :show
    end
  end
    
  private
  def resource_params
    params.permit(resource_name.to_sym).permit(:gauth_enabled)
  end
  
  def scope
    resource_name.to_sym
  end
  
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!")
    self.resource = send("current_#{resource_name}")
  end
end