source ansible-test/.env
docker image build -f ansible-test/Dockerfile -t sqlops/sybase-test-container:${SEMVER_TAG} ./