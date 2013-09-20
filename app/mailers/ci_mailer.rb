class CiMailer < ActionMailer::Base
  helper :builds
  default :from => "bennett@#{HOST}"

  def build_result(build)
    @build = build
    mail(:to => build.commit_author_email, :subject => "[CI] #{build.project.name} build #{build.status}")
  end

  def invitation(invitation)
    @invitation = invitation
    mail(:to => invitation.email, :subject => "You have been invited to #{invitation.project.name} on Bennett")
  end

end
