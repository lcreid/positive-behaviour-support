# From: http://railscasts.com/episodes/241-simple-omniauth-revised

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  # One doesn't want to put the twitter consumer key and consumer secret into a 
  # publicly accessible git repository. For now I'll have to remember to set
  # the environment before running the server.
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

