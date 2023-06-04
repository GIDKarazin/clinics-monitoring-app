class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :configure_permitted_parameters

  def new
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def create
    if User.exists?(email: params[:user][:email])
      flash[:error] = "Email is already taken, please choose a different one"
      redirect_to new_user_registration_path
    else
      build_resource(sign_up_params)
      resource.avatar.attach(params[:user][:avatar]) if params[:user][:avatar]
      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end
  end

  def edit
   super
  end

  def update
    if params[:user][:avatar].present?
      current_user.avatar.attach(params[:user][:avatar])
      redirect_to root_path, notice: "Avatar successfully updated"
    else
      super
    end
  end

  def destroy
    sign_out(resource)
    resource.destroy
    set_flash_message! :notice, :destroyed
    redirect_to root_path
  end

  def cancel
   super
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
  end
  
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
  end

  def after_sign_up_path_for(resource)
   super(resource)
  end

  def after_inactive_sign_up_path_for(resource)
   super(resource)
  end
end