# Setup

## Postgres (database)
Install Mac Application 
https://postgresapp.com/

## Redis (For jobs and action cable)
```bash
brew install redis
brew services start redis
```

## Minio (Testing s3 interactions in development)
```bash
  brew install minio/stable/minio
  minio server <PATH_TO_STORE_DATA> --address ':9002' --console-address ':9001'
```

## Setup environment variables
```bash
  cp .env.sample .env
```

## Setup Database
```bash
  bundle exec rake db:create db:migrate # add RAILS_ENV=test for test migrations
```

## Run Tests
```bash
  bundle exec rspec
```
