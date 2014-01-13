=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
# From: http://railscasts.com/episodes/241-simple-omniauth-revised

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  # One doesn't want to put the twitter consumer key and consumer secret into a 
  # publicly accessible git repository. For now I'll have to remember to set
  # the environment before running the server.
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

