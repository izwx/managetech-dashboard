class JsonFailureApp < Devise::FailureApp
  def respond
    self.status = 401
    self.content_type = "json"
    self.response_body = '{"error" : "Invalid Email or password."}'
  end
end
