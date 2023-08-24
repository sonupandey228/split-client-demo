# Use the official Ruby Alpine image as the base image
FROM ruby:3.1.4-alpine

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apk update && \
    apk add --no-cache build-base tzdata postgresql-dev nodejs npm yarn

# Install bundler gem
RUN gem install bundler

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install project gems
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Precompile assets
RUN RAILS_ENV=production bundle exec rake assets:precompile

# Expose port 3000
EXPOSE 3000

# Start the Rails application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
