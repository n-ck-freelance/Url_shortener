class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    @short_urls = ShortUrl.order(click_count: :desc).limit(100)
  end

  def create
    short_url = ShortUrl.new
    short_url.full_url = params[:full_url]
    
    if short_url.valid? && short_url.save
      render json: {
        short_code: short_url.short_code
      }
    else
      render json: { errors: short_url.errors.full_messages }, status: 400
    end
  end

  def show
    if short_url.present?
      short_url.update( click_count: short_url.click_count + 1 )
      redirect_to short_url.full_url
    else
      render json: 'Url not found!', status: 404
    end
  end

  private

  def short_url
    @_short_url ||= ShortUrl.find_by_short_code(params[:id])
  end
end
