class RoomsController < ApplicationController
  def index
    
  end

  def staff
    @staff_list = params[:staff_list]
    @user_list = @staff_list.split(',')
    @user_list
  end
end
