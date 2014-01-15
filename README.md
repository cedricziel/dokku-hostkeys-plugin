SSH HostKeys Plugin for Dokku
=============================

Manage hostkeys (for .ssh/known_hosts) to your container environment

This is useful if you hide your sourcecode in private repositories at VCS providers such as GitHub or Bitbucket.

You probably need something to manage your deployment keys as well. Checkout [dokku-deployment-keys](http://github.com/cedricziel/dokku-deployment-keys)

Installation
------------

```
git clone https://github.com/cedricziel/dokku-hostkeys-plugin.git /var/lib/dokku/plugins/hostkeys
dokku plugins-install
```

Usage
-----

Use the ``dokku hostkeys`` command for further information:

```
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

Auto-Adding Hostkeys
--------------------
There is another possibility to add host keys, if you do not want to enter a hostkey manually:
You can autoadd hosts. You provide the hostname and your Dokku host will resolve it for you.
(THIS IS NOT A GOOD PRACTICE!)
You should only do this if you are 100% sure your DNS is not compromised.

$ dokku hostkeys:shared:autoadd github.com
This command would automatically discover the hostkeys for github.com, add it to the shared
known_hosts file and add it to your apps slug on recompile.

$ dokku hostkeys:shared:autoadd mycoolapp github.com
This command would automatically discover the hostkeys for github.com, add it to your known_hosts
file for the mycoolapp app and will be compiled inside the slug on recompile.

$ dokku hostkeys:shared:autoadd github.com
This command would automatically discover the hostkeys for github.com and add it to your apps slug.

You may as well want to have a look at the dokku-deployment-keys plugin on GitHub:
http://github.com/cedricziel/dokku-deployment-keys

Projects are kept separate because they each do one different thing.

Available Commands:
-------------------
hostkeys                                        Print an explanation (Useful to get the concept)
hostkeys:shared:show                            Show shared hostkeys
hostkeys:shared:add                             Add a shared hostkey
hostkeys:shared:delete                          Deletes all shared hostkeys
hostkeys:shared:autoadd <hostname>              Automatically add hostkeys for a given host to the shared hostkeys
hostkeys:app:show <app>                         Show all hostkeys for a given app
hostkeys:app:add <app>                          Add a app-specific hostkey
hostkeys:app:delete <app>                       Deletes all app-specific hostkeys
hostkeys:app:autoadd <app> <hostname>           Automatically add hostkeys for a given host to the shared hostkeys
```

License
-------
MIT License