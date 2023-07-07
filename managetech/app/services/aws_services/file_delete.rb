class AwsServices::FileDelete < ApplicationService
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def call
    begin
      key = @url.split("amazonaws.com/")[1]
      if key.present?
        S3_BUCKET.object(key).delete
        return true
      else
        raise Exception.new("No S3 Image")
      end
    rescue => e
      raise
    end
  end
end
