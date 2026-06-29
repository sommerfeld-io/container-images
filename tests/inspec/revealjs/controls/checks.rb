title "Checks for revealjs image"

control 'revealjs-01' do
  impact 1.0
  title 'Verify the image contains node, npm, git, and the reveal.js project'
  desc 'Ensure all runtime dependencies and the cloned repository are present'

  ['/usr/local/bin/node', '/usr/local/bin/npm', '/usr/bin/git'].each do |bin|
    describe file(bin) do
      it { should exist }
      it { should be_executable }
    end
  end

  describe file('/work/reveal.js') do
    it { should be_directory }
  end

  describe file('/work/reveal.js/package.json') do
    it { should exist }
  end

  describe file('/work/reveal.js/node_modules') do
    it { should be_directory }
  end
end
