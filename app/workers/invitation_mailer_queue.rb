class InvitationMailerQueue
  @queue = 'Invitation e-mails'
  def self.perform(invitation_id)
    invitation = Invitation.find(invitation_id)
    CiMailer.invitation(invitation).deliver
  end
end