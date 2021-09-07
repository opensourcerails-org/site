class NewsletterSubscription
  attr_reader :error
  def initialize(email:)
    @email = email
    @error = nil
  end

  #
  def save
    @response = HTTP.basic_auth(user: ENV['NEWSLETTER_USER'], pass: ENV['NEWSLETTER_PASSWORD'])
    .post(ENV['NEWSLETTER_URL'], json:
      {
        email: @email,
        name: @email,
        lists: [ENV['NEWSLETTER_LIST_ID'].to_i],
        status: "enabled"
      }
    )

    return true if @response.success?

    @error = @response.parsed_response['message'] || "and I don't know what."
    false
  end
end
