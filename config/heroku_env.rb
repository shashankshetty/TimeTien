#http://andrewrdavis.net/2012/01/28/rails-devise-omniauth-heroku-facebook-twitter-and-google/

heroku_config = File.expand_path('../heroku.yml', __FILE__)
if File.exists?(heroku_config)
  config = YAML.load_file(heroku_config)
  environment = ENV["RAILS_ENV"] == "production" ? "production" : "development"
  config.fetch(environment, {}).each do |key, value|
    ENV[key.upcase] = value.to_s
  end
end