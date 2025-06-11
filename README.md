# dokku hostkeys [![Build Status](https://img.shields.io/github/actions/workflow/status/cedricziel/dokku-hostkeys/ci.yaml?branch=master&style=flat-square "Build Status")](https://github.com/cedricziel/dokku-hostkeys/actions/workflows/ci.yaml?query=branch%3Amaster) [![IRC Network](https://img.shields.io/badge/irc-libera-blue.svg?style=flat-square "IRC Libera")](https://webchat.libera.chat/?channels=dokku)

Manage hostkeys (.ssh/known_hosts) in your container environment

This is useful if you hide your sourcecode in private repositories at VCS providers such as GitHub or Bitbucket.

## Requirements

- dokku 0.19.x+
- docker 1.8.x

You probably need something to manage your deployment keys as well. Checkout [dokku-deployment-keys](http://github.com/cedricziel/dokku-deployment-keys)

## Installation

```shell
# on 0.19.x+
sudo dokku plugin:install https://github.com/cedricziel/dokku-hostkeys.git --name hostkeys
```

## Commands

```
hostkeys:add <app> <hostkey>      # adds a hostkey to the app
hostkeys:autoadd <app> <hostname> # autoadds a hostkey for the given hostname to the app
hostkeys:delete <app> <hostname>  # deletes a hostkey from the app
hostkeys:show <app>               # shows the current status of the hostkeys for an app
```

## Usage

Help for any commands can be displayed by specifying the command as an argument to hostkeys:help. Plugin help output in conjunction with any files in the `docs/` folder is used to generate the plugin documentation. Please consult the `hostkeys:help` command for any undocumented commands.

### Basic Usage

### adds a hostkey to the app

```shell
# usage
dokku hostkeys:add <app> <hostkey>
```

flags:

- `--shared`: show the shared hostkeys

Adds a hostkey to the app:

```shell
dokku hostkeys:add my-app some-key-for-github.com
```

Add a hostkey to the shared hostkeys:

```shell
dokku hostkeys:add --shared some-key-for-github.com
```

### autoadds a hostkey for the given hostname to the app

```shell
# usage
dokku hostkeys:autoadd <app> <hostname>
```

flags:

- `--shared`: show the shared hostkeys

Autoadds a hostkey to the app:

```shell
dokku hostkeys:autoadd my-app github.com
```

Autoadd a hostkey to the shared hostkeys:

```shell
dokku hostkeys:autoadd --shared github.com
```

### deletes a hostkey from the app

```shell
# usage
dokku hostkeys:delete <app> <hostname>
```

flags:

- `--shared`: show the shared hostkeys

Deletes a hostkey from the app:

```shell
dokku hostkeys:delete my-app some-key-for-github.com
```

Delete a hostkey from the shared hostkeys:

```shell
dokku hostkeys:delete --shared some-key-for-github.com
```

### shows the current status of the hostkeys for an app

```shell
# usage
dokku hostkeys:show <app>
```

flags:

- `--shared`: show the shared hostkeys

Shows the current status of the hostkeys for an app:

```shell
dokku hostkeys:show my-app
```

Show the shared hostkeys:

```shell
dokku hostkeys:show --shared
```

## How does it work?

The hostkeys plugin manages the known_hosts file for your apps.

You need those known_hosts files, when you want to open a SSH connection to a foreign host,
such as when compiling the app and pulling in dependencies.

After adding hostkeys to your Dokku host/app, they will automatically be baked in on the
next time you compile your app.

There are 2 types of keys:
1.) Shared Keys
Shared keys are valid for all your apps on the Dokku host. You may probably want to add
some popular hosts in there such as BitBucket, GitHub or even your private VCS that is reachable.

2.) App-Level Hostkeys
App-Level Hostkeys may be needed for external dependencies which you licensed, or that reside
on a different host

### Auto-Adding Hostkeys

There is another possibility to add host keys, if you do not want to enter a hostkey manually:
You can autoadd hosts. You provide the hostname and your Dokku host will resolve it for you.
(THIS IS NOT A GOOD PRACTICE!)
You should only do this if you are 100% sure your DNS is not compromised.

$ dokku hostkeys:autoadd --shared github.com
This command would automatically discover the hostkeys for github.com, add it to the shared
known_hosts file and add it to your apps slug on recompile.

$ dokku hostkeys:autoadd mycoolapp github.com
This command would automatically discover the hostkeys for github.com, add it to your known_hosts
file for the mycoolapp app and will be compiled inside the slug on recompile.

You may as well want to have a look at the [dokku-deployment-keys plugin](http://github.com/cedricziel/dokku-deployment-keys).

Projects are kept separate because they each do one different thing.

