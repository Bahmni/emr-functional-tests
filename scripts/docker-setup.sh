docker stop bahmni
docker rm -v bahmni

docker run -v /var/lib/go-agent/pipelines/Functional_Tests/emr-functional-tests/:/emr-functional-tests -v /var/lib/go-agent/pipelines/Functional_Tests/rpms:/packages -p 8080:8080 -p 443:443 --name bahmni -d bahmni/bahmni
