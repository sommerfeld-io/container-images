title "Checks for devcontainer image"

control 'devcontainer-01' do
  impact 1.0
  title 'Verify the image is suitable for use as a devcontainer'
  desc 'Ensure the image contains essential tools and configurations'

  describe file('/usr/local/bin/git') do
    it { should exist }
    it { should be_executable }
  end

  describe file('/usr/bin/curl') do
    it { should exist }
    it { should be_executable }
  end

  describe file('/usr/bin/vim') do
    it { should exist }
    it { should be_executable }
  end

  describe file('/usr/bin/task') do
    it { should exist }
    it { should be_executable }
  end

  describe file('/home/vscode/.atuin/bin/atuin') do
    it { should exist }
    it { should be_executable }
  end
end

control 'devcontainer-02' do
  impact 1.0
  title 'Verify the container is run as user vscode'
  desc 'Ensure the container is configured to run as the vscode user.'

  describe user('vscode') do
    it { should exist }
    its('uid') { should eq 1000 }
    its('home') { should eq '/home/vscode' }
  end
end
