if Rails.application.config.active_storage.service == :cloudflare
  require 'aws-sdk-core'

  Aws.config[:credentials] = Aws::Credentials.new(
    Rails.application.credentials.dig(:aws, :access_key_id),
    Rails.application.credentials.dig(:aws, :secret_access_key),

  )

end

