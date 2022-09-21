source ansible-test/.env
docker image build -f ansible-test/Dockerfile.ci -t docker.io/sqlops/sybase-test-container ./
docker image build -f ansible-test/Dockerfile.ci -t docker.io/sqlops/sybase-test-container:${SEMVER_TAG} ./