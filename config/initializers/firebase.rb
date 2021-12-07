creds = Firebase::Admin::Credentials.from_file(Rails.root.join('config/firebase_integration.json'))
FIREBASE_APP = Firebase::Admin::App.new(credentials: creds)


