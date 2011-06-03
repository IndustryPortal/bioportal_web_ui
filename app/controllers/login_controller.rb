class LoginController < ApplicationController
  
  layout 'ontology'

  def index
    # Sets the redirect properties
    if params[:redirect]
      session[:redirect] = params[:redirect]
    else
      session[:redirect] = request.referer
    end
  end
  
  # logs in a user
  def create
    @errors = validate(params[:user])
    if @errors.size < 1
      logged_in_user = DataAccess.authenticateUser(params[:user][:username],params[:user][:password])
      if logged_in_user
        session[:user] = logged_in_user
        flash[:notice] = "Welcome " + logged_in_user.username.to_s+"."
        redirect = "/"

        if session[:redirect]
          redirect = session[:redirect]
        end

        redirect_to redirect
      else
        @errors << "Invalid account name/password combination"
        render :action => 'index'
      end
    else
      render :action => 'index'
    end
  end
  
  # logs out a user
  def destroy
    session[:user] = nil
    flash[:notice] = "Logged out"
    redirect_to request.referer
  end
    
  def lost_password
    
  end
  
  # Sends a new password to the user
  def send_pass
    user = DataAccess.getUserByUsername(params[:user][:account_name])
    
    if !user.nil? && !user.email.downcase.eql?(params[:user][:email].downcase)
      user = nil
    end
    
    if user.nil?
      flash[:notice]="No account exists with that email address and account name combination"
      redirect_to :action=>'lost_password'
    else       
      new_password = newpass(8)
      user.password = new_password
      DataAccess.updateUser(user.to_h,user.id)
      
      Notifier.deliver_lost_password(user,new_password)
      flash[:notice]="Your password has been sent to your email address"
      redirect_to_home
    end
  end
  
  private 
  
  def validate(params)
    errors=[]
    
    if params[:username].nil? || params[:username].length <1
      errors << "Please enter an account name"
    end
    if params[:password].nil? || params[:password].length <1
      errors << "Please enter a password"
    end
    
    return errors
  end
  
  
end
