require 'spec_helper'

describe Result do
  it "can be pending" do
    result = Result.new :status_id => Result::STATUS[:pending]
    result.status.should eql(:pending)
    result.in_status?(:pending).should be_true
    result.pending?.should be_true
  end

  it "can be busy" do
    result = Result.new :status_id => Result::STATUS[:busy]
    result.status.should eql(:busy)
    result.in_status?(:busy).should be_true
    result.busy?.should be_true
  end

  it "can be failed" do
    result = Result.new :status_id => Result::STATUS[:failed]
    result.status.should eql(:failed)
    result.in_status?(:failed).should be_true
    result.failed?.should be_true
  end

  it "can be passed" do
    result = Result.new :status_id => Result::STATUS[:passed]
    result.status.should eql(:passed)
    result.in_status?(:passed).should be_true
    result.passed?.should be_true
  end

  it "can be skipped" do
    result = Result.new :status_id => Result::STATUS[:skipped]
    result.status.should eql(:skipped)
    result.in_status?(:skipped).should be_true
    result.skipped?.should be_true
  end

  it "defaults to pending with logpath from project name and build name" do
    build = stub_model Build
    command = stub_model Command
    project = stub_model Project
    build.should_receive(:project).and_return(project)
    project.should_receive(:name).and_return("My Awesome Project")
    command.should_receive(:name).and_return("My Test Command")
    result = Result.new :build => build, :command => command
    result.save.should be_true
    result.pending?.should be_true
    result.log_path.present?.should be_true
  end
end