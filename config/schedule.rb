every 1.day, :at => '1:00 am' do
  runner "Project.build_all_nightly!"
end
