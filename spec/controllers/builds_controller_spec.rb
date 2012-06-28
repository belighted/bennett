require 'spec_helper'

describe BuildsController do
  extend CanSpec

  can_spec(:build, {
    user: [],
    auditor: [],
    developer: [:create],
    admin: [:create, :destroy],
    global_admin: [:create, :destroy]
  }, methods: [:create, :destroy], nested_in: :project)
end
