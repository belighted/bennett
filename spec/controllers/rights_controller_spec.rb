require 'spec_helper'

describe RightsController do
  extend CanSpec

  can_spec(:right, {
    user: [],
    auditor: [],
    developer: [],
    admin: [:update, :destroy],
    global_admin: [:update, :destroy]
  }, methods: [:update, :destroy], nested_in: :project)
end
