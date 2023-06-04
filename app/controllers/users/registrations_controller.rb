class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

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
      super
    end
  end

  def edit
   super
  end

  def update
   super
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

  def configure_sign_up_params
   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  def configure_account_update_params
   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  end

  def after_sign_up_path_for(resource)
   super(resource)
  end

  def after_inactive_sign_up_path_for(resource)
   super(resource)
  end
end