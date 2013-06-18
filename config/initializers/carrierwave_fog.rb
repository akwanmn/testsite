CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
    #:region                 => 'us-east-1'
  }
  config.fog_directory  = 'profile.images.2date4love.com'
  #config.asset_host     = 'https://assets.example.com'
  #
  config.fog_public     = false
  config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
end