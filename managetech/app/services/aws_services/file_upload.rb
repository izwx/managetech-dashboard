class AwsServices::FileUpload < ApplicationService
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def call
    begin
      obj = S3_BUCKET.object("profile-images/#{SecureRandom.uuid}/#{@file.original_filename}")
      obj.put(body: @file.to_io, acl: "public-read")
      return obj
    rescue => e
      raise
    end
  end
end
