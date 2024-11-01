# Instructions

Replace AppName and app_name with your app name.

## Starting the app

```
docker compose build
docker compose run --rm app bundle exec rake db:create db:migrate
docker compose run --rm app bundle exec rake assets:precompile
docker compose up
```

## Generating new engine

```ruby
rails g engine engine_name
```