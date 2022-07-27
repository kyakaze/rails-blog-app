class HomeController < ApplicationController
  def home
    render 'home/home_page'
  end

  def about_us
    render 'home/about_us'
  end
end
