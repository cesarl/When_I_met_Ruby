class HomeController < ApplicationController
  def index
    @posts = Post.find(:all, :order => "created_at DESC", :limit => 5)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end
end
