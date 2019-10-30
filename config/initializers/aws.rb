# frozen_string_literal: true

Aws.config.update(
  credentials: Aws::Credentials.new(ENV["AWS_KEY"], ENV["AWS_SECRET"]),
  region: "us-east-1"
)
