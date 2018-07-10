# frozen_string_literal: true

module GetBack
  extend ActiveSupport::Concern

  included do
    before_action :set_back, only: %i[edit new]
  end
  #
  # # Set the URL to which to return after creating or updating something.
  # def set_back
  #   session[:here_after_save] = request.headers["HTTP_REFERER"]
  #   # puts session[:here_after_save]
  # end
  #
  # # Return the URL that started the create or update.
  # def where_we_came_from_url(fallback = root_path)
  #   session[:here_after_save] || fallback
  # end
  # helper_method :where_we_came_from_url
end
