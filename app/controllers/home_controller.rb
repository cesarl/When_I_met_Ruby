class HomeController < ApplicationController
  def index
    @posts = Post.limit(5).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end
end
