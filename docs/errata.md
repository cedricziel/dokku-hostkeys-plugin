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
