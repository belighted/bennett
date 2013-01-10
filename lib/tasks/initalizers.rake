desc 'Generates a secret token for the application.'

file 'config/initializers/secret_token.rb' do
  path = File.join(Rails.root, 'config', 'initializers', 'secret_token.rb')
  secret = SecureRandom.hex(64)
  File.open(path, 'w') do |f|
    f.write <<"EOF"
# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Bennett::Application.config.secret_token = '#{secret}'
EOF
  end
end

desc 'Generates a secret token for the application.'
task :generate_secret_token => ['config/initializers/secret_token.rb']