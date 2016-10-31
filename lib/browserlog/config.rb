require 'singleton'

module Browserlog
  class Config
    include Singleton

    attr_accessor :allow_production_logs, :allowed_log_files

    def initialize
      @allow_production_logs = true
      @allowed_log_files = %w(test development production)
    end
  end
end
