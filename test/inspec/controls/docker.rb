control "Docker Image Verification" do
  impact 1.0
  title "Check image created with correct version"
  desc "Check image created with correct version"

    describe docker_image('pearsontechnology/image-base:latest') do
      it { should exist }
      its('image') { should eq 'pearsontechnology/image-base:latest' }
      its('repo') { should eq 'pearsontechnology/image-base' }
      its('tag') { should eq 'latest' }
    end

    describe file('/etc/docker-base-image-info.txt') do
      its('content') { should match("IMAGE_TAG=pearsontechnology/image-base:latest") }
    end
end
