title "Checks for devcontainer image"

control 'devcontainer-01' do
  impact 1.0
  title 'Verify the image is suitable for use as a devcontainer'
  desc 'Ensure the image contains essential tools and configurations'

  should_exist = [
    '/usr/bin/curl',
    '/usr/bin/neofetch',
    '/usr/bin/ping',
    '/usr/bin/task',
    '/usr/bin/vim',
    '/usr/local/bin/git',
    '/home/vscode/.atuin/bin/atuin',
  ]
  should_exist.each do |binary|
    describe file(binary) do
      it { should exist }
      it { should be_executable }
    end
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
