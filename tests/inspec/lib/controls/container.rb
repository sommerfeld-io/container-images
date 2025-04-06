title "Common checks for container images"

control 'container-01' do
  impact 1.0
  title 'Verify container image properties'
  desc 'Ensure the container image is running a valid base OS, contains necessary tools, and does not run as root.'

  describe command('cat /etc/os-release') do
    its('stdout') { should match(/(Alpine|Ubuntu)/) }
  end

  describe package('bash') do
    it { should be_installed } if file('/etc/os-release').content.match?(/Ubuntu/)
  end

  describe package('ash') do
    it { should be_installed } if file('/etc/os-release').content.match?(/Alpine/)
  end
end
