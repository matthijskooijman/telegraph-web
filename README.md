Orenda Morse Terminal
=====================

The code that goes with a physrep for telegraph devices

Requirements
------------
* A working Redis installation at the default port
* Some libraries preinstalled that make the installation step work. You'll notice if you don't have them.

Installation
------------

After checking out the project, go to its directory and type:
```
bundle
RAILS_ENV=production rake db:setup assets:precompile
```

and you're done!

Usage
-----

In one terminal, you just go:
```
RAILS_ENV=production rails s -b0
```
and in another terminal, you go like:
```
ruby pubsubserial.rb
```

You can now visit the command center at http://{ipaddress}:3000

Happy, err, messaging?
