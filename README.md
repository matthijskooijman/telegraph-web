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
sudo cp telegraph-web.socket telegraph-web.service /etc/systemd/system
sudo systemctl enable telegraph-web.socket telegraph-web.service
```

You might need to update the `ExecStart` and `User` attributes in the
`.service` file if you made checkout in a different place. Also, don't forget
to setup the telegraph-controller daemon to actually talk to the hardware.

After a reboot (or `sudo systemctl start telegraph-web.socket`), you can visit
the command center at http://{ipaddress}

Happy, err, messaging?

Manual start
------------
In a terminal, you just go:
```
RAILS_ENV=production rails server
```

This runs on a different port, so connect to http://{ipaddress}:3000

Legacy
------
In the first hardware version, the hardware was controlld by an Arduino, and a
ruby script was used to talk to that Arduino:

```
ruby pubsubserial.rb
```
