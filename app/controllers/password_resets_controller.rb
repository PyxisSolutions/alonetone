class PasswordResetsController < ApplicationController  
  
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]  
  
  
  def edit
  end
  
  def create  
    email = params[:email].present? ? params[:email].first : nil
    @user = User.where(:email => email).first 
    if @user  
      @user.reset_perishable_token!
      UserNotification.forgot_password(@user).deliver
      flash[:notice] = "Check your email and click the link to reset your password!"
      redirect_to login_path
    else  
      flash[:notice] = "Uhm. Uh oh. No user was found with that email address, maybe it was a different email?"  
      redirect_to login_path
    end  
  end  
  
  def update  
    @user.password = params[:subscriber][:password]  
    @user.password_confirmation = params[:subscriber][:password_confirmation]  
    if @user.save  
      flash[:notice] = "Password successfully updated! Enjoy a much easier life from here on out."  
      @user.clear_token!
      redirect_to issues_url  
    else 
      flash[:notice] = "Please try again. The password and confirmation has to match!"
      redirect_to login_path
    end  
  end  

  private  
 
  def load_user_using_perishable_token  
    @user = User.find_using_perishable_token(params[:id])  
    unless @user  
      flash[:notice] = "Hmmm...that didn't work. If you still have issues, email #{Alonetone.email}"
      redirect_to login_path
    end
  end
  
end