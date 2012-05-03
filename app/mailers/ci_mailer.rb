class CiMailer < ActionMailer::Base
  default :from => "no-reply@ci.belighted.com"

  def build_result(build)
    @build = build
    mail(:to => build.commit_author_email, :subject => "[CI] #{build.commit_message} - #{build.status}")
  end

  def invitation(invitation)
    @invitation = invitation
    mail(:to => invitation.email, :subject => "You have been invited to #{invitation.project.name} on Bennett")
  end

end