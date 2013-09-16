# -*- encoding : utf-8 -*-
class UserSessionsController < ApplicationController
  def new
    @page_title = "Login"
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session]) #always stay logged in
    if @user_session.save
      redirect_to user_home_path(@user_session.user)
    else
      if params[:user_session][:login] && (user = User.find_by_login(params[:user_session][:login])) && !user.active?
        flash.now[:error] = "It looks like your account is not active. <br/> Do you have an email from us with activation details?".html_safe
      else
        flash.now[:error] = "There was a problem logging you in! Please re-check your email and password."
      end
      render :action => :new
    end
  end

  def destroy
    if logged_in?
      current_user_session.destroy
      redirect_to login_path, :notice => "We've logged you out. Your secrets are safe with us!"
    else
      redirect_to login_path, :error => "You weren't logged in to begin with, old chap/dame!"
    end
  end
end