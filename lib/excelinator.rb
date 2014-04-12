require 'excelinator/xls'
require 'excelinator/rails'
require 'excelinator/version'
require 'spreadsheet'
require 'csv'

if defined?(Rails)
  Excelinator::Rails.setup
  class ActionController::Base
    include Excelinator::Rails::ACMixin
  end
end