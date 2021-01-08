# BeSman

**BeSman** , is a command line utility !!
BeSMan gives you a *bes* command on your shell , you can use it to automate the setup of various development environments required for BeS projects  


# BeSman! CLI
### The Command Line Interface<!--Text-->

<!--Text-->


BeSMAN is a tool for managing parallel Versions of multiple KochiOrgBook projects on any Unix based system. It provides a convenient command line interface for installing, removing and listing Environments.

See documentation on the [BeSMAN! website](https://besman.github.io).

## System pre-requisite

  - OS          : Ubuntu 18.04LTS
  - Memory[RAM]): 4GB (min)
  - Storage     : 30GB (min)


## Installation

Open your favourite terminal and enter the following:

    $ curl -L https://raw.githubusercontent.com/mohatte/BeSman/BeSman/master/dist/get.besman.io | bash

If the environment needs tweaking for BeSMAN to be installed, the installer will prompt you accordingly and ask you to restart.


### Local Installation

To install BeSMAN locally running against your local server, run the following commands:


	$ source ~/.besman/bin/besman-init.sh


### Local environment commands

Run the following commands on the terminal to manage respective environments.

### Install commands:

        $ bes install -env [environment_name] --version [version_tag]

        Example   :
           $ bes install -env BeSman --version 0.0.2

Please run the following command to get the list of other environments and its versions.

	   	`$ bes list`

____________________

### Uninstall commands:

        $ bes uninstall -env [environment_name] --version [version_tag]

        Example   :
           $ bes uninstall -env BeSman --version 0.0.2

____________________

### Version commands:

    $ bes --version
    $ bes --version -env [environment_name]

    Example   :
       $ bes --version -env BeSman

____________________

### Other useful commands:        

        $ bes list
        $ bes status        
        $ bes help     

## Contributors

This project exists thanks to all the people who contribute.
<a href="https://github.com/besman/BeSman/graphs/contributors"><img src="https://i.stack.imgur.com/kk4j4.jpg" /></a>
