require 'spec_helper'

describe Build do
  it "has status passed if all results passed" do
    result_1 = stub_model Result, status_id: Result::STATUS[:passed]
    result_2 = stub_model Result, status_id: Result::STATUS[:passed]
    build = Build.new results: [result_1, result_2]
    build.status.should eql(:passed)
  end

  it "has status busy if any results is busy" do
    result_1 = stub_model Result, status_id: Result::STATUS[:busy]
    result_2 = stub_model Result, status_id: Result::STATUS[:pending]
    build = Build.new results: [result_1, result_2]
    build.status.should eql(:busy)
  end

  it "has status failed if any results is busy" do
    result_1 = stub_model Result, status_id: Result::STATUS[:failed]
    result_2 = stub_model Result, status_id: Result::STATUS[:skipped]
    build = Build.new results: [result_1, result_2]
    build.status.should eql(:failed)
  end

  it "delegates start_time and end_time to results" do
    result = stub_model Result
    build = Build.new :results => [result]
    result.should_receive(:start_time)
    build.start_time
    result.should_receive(:end_time)
    build.end_time
  end

  it "can be skipped" do
    result = stub_model Result
    build = Build.new :results => [result]
    build.skip!
    result.skipped?.should be_true
  end

  it "can update git" do
    project = stub_model Project, folder_path: '/tmp', branch: 'master'
    git = stub
    git.stub(:reset_hard)
    git.stub(:checkout)
    git.should_receive(:pull)
    Git.should_receive(:open).and_return(git)
    build = Build.new project: project
    build.update_commit!
  end

  it "can build" do
    project = stub_model Project, folder_path: '/tmp'
    result = stub_model Result
    build = Build.new project: project, results: [result]
    build.should_receive(:update_commit!)
    result.should_receive(:command).and_return(stub_model Command, command: 'ls -l')
    result.should_receive(:log_path).and_return('/tmp/bennett_spec_build.log')
    mailstub = stub
    CiMailer.should_receive(:build_result).with(build).and_return(mailstub)
    mailstub.should_receive(:deliver)
    build.build!
  end
end
