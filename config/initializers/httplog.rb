HttpLog.options[:logger] = Rails.logger if Rails.env.development? || Rails.env.testing?
