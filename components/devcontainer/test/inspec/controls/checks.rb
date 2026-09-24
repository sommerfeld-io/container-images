title "Checks for devcontainer image"

ansible_variant = input('ansible_variant', value: false)
go_variant = input('go_variant', value: false)

control 'devcontainer-01' do
  impact 1.0
  title 'Verify the image is suitable for use as a devcontainer'
  desc 'Ensure the image contains essential tools and configurations'

  should_exist = [
    '/usr/bin/curl',
    '/usr/bin/fastfetch',
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

control 'devcontainer-03' do
  impact 1.0
  title 'Verify the ansible variant contains ansible-dev-tools'
  desc 'Ensure the optional ansible stage exposes the expected ansible tooling on PATH.'
  only_if('only runs for the ansible devcontainer variant') do
    ansible_variant
  end

  should_exist = [
    '/opt/venvs/ansible-dev-tools/bin/ansible',
    '/opt/venvs/ansible-dev-tools/bin/ansible-lint',
    '/opt/venvs/ansible-dev-tools/bin/ansible-navigator',
    '/opt/venvs/ansible-dev-tools/bin/molecule',
  ]
  should_exist.each do |binary|
    describe file(binary) do
      it { should exist }
      it { should be_executable }
    end
  end

  describe os_env('PATH').content do
    it { should match(%r{^/opt/venvs/ansible-dev-tools/bin:}) }
  end
end

control 'devcontainer-04' do
  impact 1.0
  title 'Verify the go variant contains the Go toolchain and editor tooling'
  desc 'Ensure the optional go stage exposes Go, gopls, dlv, and native build tooling.'
  only_if('only runs for the go devcontainer variant') do
    go_variant
  end

  should_exist = [
    '/usr/local/go/bin/go',
    '/usr/local/bin/gopls',
    '/usr/local/bin/dlv',
    '/usr/bin/gcc',
  ]
  should_exist.each do |binary|
    describe file(binary) do
      it { should exist }
      it { should be_executable }
    end
  end

  describe command('go version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/^go version go/) }
  end

  describe os_env('PATH').content do
    it { should match(%r{^/usr/local/go/bin:}) }
  end
end
