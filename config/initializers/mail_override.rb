if Rails.env.development?
  class OverrideMailReciptient
    def self.delivering_email(mail)
      mail.to = `git config user.email`.chomp
    end
  end
  ActionMailer::Base.register_interceptor(OverrideMailReciptient)
end