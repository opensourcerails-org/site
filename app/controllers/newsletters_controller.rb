# frozen_string_literal: true

class NewslettersController < ApplicationController
  skip_after_action :track_action

  def show
    set_meta_tags title: "Newsletter"
  end

  def create
    @response = HTTP.post("https://api.convertkit.com/v3/forms/#{ENV['CONVERTKIT_FORM_ID']}/subscribe", json: {
                            api_key: ENV['CONVERTKIT_API_KEY'],
                            email: params[:newsletter][:email_address]
                          })
    if @response.parsed_response['error']
      @error = {
        'Missing parameter' => 'email is invalid.'
      }[@response.parsed_response['error']] || 'unable to subscribe.'
    end

    if @error
      return respond_to do |f|
        f.turbo_stream do
          render turbo_stream: turbo_stream.replace(:newsletter_error, template: '/newsletters/error.turbo.erb')
        end
      end
    end
    respond_to do |f|
      f.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(:newsletter_error),
          turbo_stream.replace(:newsletter, template: '/newsletters/create.turbo.erb')
        ]
      end
    end
  end
end
