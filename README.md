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