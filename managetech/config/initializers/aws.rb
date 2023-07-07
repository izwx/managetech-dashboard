Aws.config.update({
  region: "ap-northeast-1", # NOTE: Your region may differ
  credentials: Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]),
})

S3_BUCKET = Aws::S3::Resource.new.bucket("managetech-s3")
