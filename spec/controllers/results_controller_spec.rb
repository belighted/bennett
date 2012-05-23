require 'spec_helper'

describe ResultsController do
  extend CanSpec

  can_spec(:result, {
    user: [],
    auditor: [:show],
    developer: [:show],
    admin: [:show],
    global_admin: [:show]
  }, methods: [:show], nested_in: [:project, :build])
end
