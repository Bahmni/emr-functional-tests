Functional tests suit for emr apps

## Development

* Install RVM and ruby 1.9.3

            curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3

* Use Ruby 1.9.3

            rvm use 1.9.3

* Set up database using base dbdump

            ./scripts/setup_database.sh

* Running tests

            ./scripts/run.sh