title "Checks for devcontainer image"

include_controls 'lib' do
end

include_controls 'linux-baseline' do
  skip_control 'os-14'
end

control 'binaries-01' do
  impact 1.0
  title 'Verify the image is suitable for use as an ftp client'
  desc 'Ensure the image contains essential tools and configurations'

  describe file('/usr/bin/ncftp') do
    it { should exist }
    it { should be_executable }
  end
end
