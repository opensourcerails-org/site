# frozen_string_literal: true

class NewslettersController < ApplicationController
  skip_after_action :track_action

  def show
    set_meta_tags title: "Newsletter"
  end

  def create
    @subscription = NewsletterSubscription.new(email: params[:newsletter][:email_address])

    if @subscription.save
      respond_to do |f|
        f.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(:newsletter_error),
            turbo_stream.replace(:newsletter, template: '/newsletters/create.turbo.erb')
          ]
        end
      end
    else
      respond_to do |f|
        f.turbo_stream do
          render turbo_stream: turbo_stream.append(:newsletter_error, template: '/newsletters/error.turbo.erb')
        end
      end
    end
  end
end
