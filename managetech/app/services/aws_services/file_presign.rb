class AwsServices::FilePresign < ApplicationService
  def initialize(prefix, filename)
    @prefix = prefix
    @filename = filename
  end

  def call
    extname = File.extname(@filename)
    filename = "#{SecureRandom.uuid}#{extname}"

    data = S3_BUCKET.presigned_post(key: "#{@prefix}/${filename}", success_action_status: "201", acl: "public-read")

    return { url: data.url, fields: data.fields }
  end
end
