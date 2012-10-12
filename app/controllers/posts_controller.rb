# -*- coding: utf-8 -*-
class PostsController < ApplicationController

  require "prawn"

  def get_rss
    @posts = Post.all
    format.xml { render xml: @post }
  end

  def get_pdf
    post = Post.find(params[:id])
    send_data generate_pdf(post), :filename => "#{post.title}.pdf", :type => "application/pdf"
  end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.find(:all, :order => "created_at DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
      format.xml { render xml: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
      format.xml { render xml: @post }
      format.pdf { get_pdf }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private

  def generate_pdf(post)
    Prawn::Document.new do
      text "#{post.title} <3", :size => 20
      text post.body, :size => 12
      text "\n\n Je ne mets pas l'url de l'article car pour le moment je n'ai pas trop exploré le routing", :size => 9
    end.render
  end

end
