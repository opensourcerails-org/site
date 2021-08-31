# frozen_string_literal: true

if Rails.env.development?
  AdminUser.create!(email: 'admin@example.com', password: 'password',
                    password_confirmation: 'password')

  ActsAsTaggableOn::Tag.create!(name: 'react', data: { notable: true, stack: true })
  ActsAsTaggableOn::Tag.create!(name: 'sidekiq', data: { notable: true, stack: true })
end
