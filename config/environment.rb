# Load the Rails application.
require File.expand_path('../application', __FILE__)

  # config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
  #   File.directory?(lib = "#{dir}/lib") ? lib : dir
  # end << "#{RAILS_ROOT}/app/sweepers"

ActionMailer::Base.smtp_settings = {
  :user_name => 'cbcl-sdu',
  :password => 'Bente1Tina2Niels3',
  :domain => 'cbcl-sdu.dk',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

Rails.application.config.filter_parameters += [:password, :password_confirmation]
Rails.application.config.action_dispatch.cookies_serializer = :hybrid

# Initialize the Rails application.
Cbcl4::Application.initialize!

module Enumerable
  def to_hash_with_key
    result = {}
    each do |elt|
      result[yield(elt)] = elt
    end
    result
  end
end