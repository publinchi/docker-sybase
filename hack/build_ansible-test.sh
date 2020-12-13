source ansible-test/.env
docker image build --progress "plain" -f ansible-test/Dockerfile.ci -t sqlops/sybase-test-container:${SEMVER_TAG} ./