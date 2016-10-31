class LogsController < ApplicationController
  before_filter :check_env
  before_filter :check_auth

  layout 'logs'

  def index
    @filename = "#{params[:env]}.log"
    @filepath = Rails.root.join("log/#{@filename}")
  end

  def changes
    lines, last_line_number = reader.read(offset: params[:currentLine].to_i, log_file_name: params[:env])

    respond_to do |format|
      format.json do
        render json: {
          lines: lines.map! { |line| colorizer.colorize_line(line) },
          last_line_number: last_line_number
        }
      end
    end
  end

  private

  def reader
    Browserlog::LogReader.new
  end

  def colorizer
    Browserlog::LogColorize.new
  end

  def check_env
    # raise unless Browserlog.config.allowed_log_files.include?(params[:env])
    !current_user.nil? && current_user.access?(:superadmin)
  end

  def check_auth
    # raise 'Logs not allowed on production environment.' if Rails.env.production? # && !Browserlog.config.allow_production_logs
    !!current_user && current_user.access?(:superadmin)
  end
end