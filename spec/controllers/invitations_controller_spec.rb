require 'spec_helper'

describe InvitationsController do
  extend CanSpec

  can_spec(:invitation, {
    user: [],
    auditor: [],
    developer: [],
    admin: [:update, :destroy],
    global_admin: [:update, :destroy]
  }, methods: [:update, :destroy], nested_in: :project)
end
