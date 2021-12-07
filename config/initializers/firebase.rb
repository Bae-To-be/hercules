creds = Firebase::Admin::Credentials.from_file(Rails.root.join(ENV.fetch('FIREBASE_CONFIG_PATH')))
FIREBASE_APP = Firebase::Admin::App.new(credentials: creds)


