class CiMailer < ActionMailer::Base
  default :from => "no-reply@ci.belighted.com"

  def build_result(build)
    @build = build
    mail(:to => build.commit_author_email, :subject => "[CI] #{build.commit_message} - #{build.status}")
  end

end