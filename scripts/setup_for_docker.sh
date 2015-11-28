rm -f /tmp/emr-functional-tests
ln -s `pwd`/emr-functional-tests /tmp/emr-functional-tests
rm -f /tmp/packages
ln -s `pwd`/rpms /tmp/packages
(docker run -v /tmp/emr-functional-tests/:/emr-functional-tests -v /tmp/packages:/packages -p 8080:8080 -p 443:443 --name bahmni -d bahmni/bahmni) || true
