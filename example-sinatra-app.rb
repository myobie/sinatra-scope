require 'sinatra/base'
require 'sinatra/scope'

class MyApp < Sinatra::Base

  scope "admin" do
    get "login" do
      haml :login
    end
  end

  resource "pages" do
    index do
      @pages = Pages.all
      haml :index
    end

    new do
      @page = Page.new
      haml :new
    end

    create do
      @page = Page.create params[:page]
      redirect @page
    end

    get "/search/:q" do
      @search = Search.new params[:q]
      haml :search
    end

    member do

      show do |id|
        @page = Page.get id
        haml :show
      end

      edit do |id|
        @page = Page.get id
        haml :edit
      end

      update do |id|
        @page = Page.get id
        @page.update params[:page]
        redirect @page
      end

      delete do |id|
        @page = Page.get id
        haml :delete
      end

      destroy do |id|
        @page = Page.get id
        @page.destroy
        redirect :index
      end

      put "/restore" do |id|
        @page = Page.get id
        @page.restore
        redirect @page
      end

    end
  end

end
