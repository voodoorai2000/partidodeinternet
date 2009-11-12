class UsersController < ApplicationController    
  before_filter :load_user, :only => [:edit, :update, :show, :destroy]
  before_filter :login_required, :authorize, :only => :edit
  
  def  index
    @users = User.all
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Gracias, tus datos se han actualizado correctamente."
      redirect_to users_path
    else
      render :action => :edit
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      flash[:notice] = "¡Gracias! Te hemos mandado un email para activar tu cuenta."
      redirect_to thank_you_url
    else
      flash[:error]  = ""
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Cuenta activada, gracias!"
      self.current_user = user
      redirect_to edit_user_url(user)
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
  def destroy
    @user.delete
    redirect_to "/users"
  end
  
  def ranking
    @user_regions = User.ranking
  end
  
  protected
  
  def load_user
    @user = User.find(params[:id])
  end
  
  def authorize
    unless 
      current_user == @user or 
      current_user.is_admin?
      redirect_to "/login"
    end
  end

end
