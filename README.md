Functional tests suit for emr apps

## Development

* Install RVM and ruby 2.3.1

            curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3.1

* Use Ruby 2.3.1

            rvm use 2.3.1

* Set up database using base dbdump

            ./scripts/setup_database.sh

* Running tests

            ./scripts/run.sh
