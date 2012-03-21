require 'spec_helper'

describe Project do
  it "has no_builds status when no build" do
    project = Project.new
    project.status.should eql(:no_builds)
  end

  it "has the status of last build" do
    build = stub_model Build
    build.should_receive(:status).and_return(:passed)
    project = Project.new :builds => [build]
    project.status.should eql(:passed)
  end
end