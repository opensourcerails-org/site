# frozen_string_literal: true

ms_to_round_sec = ->(ms) { (ms.to_f / 1000).round(6) }

if (defined?(::Sidekiq) && Sidekiq.server?).nil?
  Rails.application.reloader.to_prepare do
    filename = File.join(Rails.root, 'log', "#{Rails.env}_json.log")

    Rails.application.configure do
      config.lograge.enabled = Rails.env.production?
      config.lograge.formatter = Lograge::Formatters::Json.new
      config.lograge.logger = ActiveSupport::Logger.new(filename)
      config.lograge.before_format = lambda do |data, _payload|
        data.delete(:error)
        data[:db_duration_s] = ms_to_round_sec.call(data.delete(:db)) if data[:db]
        data[:view_duration_s] = ms_to_round_sec.call(data.delete(:view)) if data[:view]
        data[:duration_s] = ms_to_round_sec.call(data.delete(:duration)) if data[:duration]
        data[:location] = data[:location] if data[:location]

        %i[method path format].each do |key|
          data[key] = nil if data[key] == {}
        end

        data
      end
    end
  end
end
