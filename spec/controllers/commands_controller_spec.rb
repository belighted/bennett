require 'spec_helper'

describe CommandsController do
  extend CanSpec

  can_spec(:command, {
    user: [],
    auditor: [],
    developer: [],
    admin: [:new, :edit, :create, :update, :destroy],
    global_admin: [:new, :edit, :create, :update, :destroy]
  }, methods: [:new, :edit, :create, :update, :destroy], nested_in: :project)
end
