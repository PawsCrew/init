Init

An extendable bash script to use as an entry point to provision ansible

## Getting Started

 These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You'll need to bake an ami or inject the script in the userdata, you want to copy the bootstrap.sh and 
inject as usardata like so:

```
data "template_file" "user_data" {
  template = "${file("${path.module}/bootstrap.sh.tpl")}"

  vars {
    is_ansible       = "no"
    has_data_storage = "yes"
    role             = "some_ansible_role"
    init_path        = "/tmp"
  }
}

```

### Installing

## Running the tests

To run your tests, invoke the bats interpreter with a path to a test file. i
The file's test cases are run sequentially and in isolation. If all the test cases pass, bats exits with a 0 status code. If there are any failures, bats exits with a 1 status code.

```
bats tests/main.bats
```

### And coding style tests

## Deployment

Add additional notes about how to deploy this on a live system

## Contributing

 Please read [CONTRIBUTING.md](https://github.com/PawsCrew/init/blob/master/CONTRIBUTING.md) 
 for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

Only master, the latest and greatest, retrocompatibility is required between versions

## Acknowledgments

 * Watch your steps!

