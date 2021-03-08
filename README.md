# Anishin Server

This is a build system for the [Ryzom](https://ryzom.com) MMORPG server.

## Overview

I have forked the various services that make up the game's server.

https://github.com/anishin-mmorpg/ryzom-common

https://github.com/anishin-mmorpg/ryzom-nel

https://github.com/anishin-mmorpg/ryzom-nelns

https://github.com/anishin-mmorpg/ryzom-server

https://github.com/anishin-mmorpg/ryzom-tools

https://github.com/anishin-mmorpg/ryzom-web

The intent is to create a build system for them that is easy to use and understand. The open source code was spread out over a variety of different [websites](https://sourceforge.net/projects/ryzom/), [repositories](https://github.com/ryzom/), and [branches](https://github.com/ryzom/ryzomcore/tree/ryzomclassic-develop), and no single place had a working system. I have consolidated the working code and written some scripts to automate the build process.

The official documentation is also outdated and missing a lot of critical things. I hope to properly document the entire architecture and make it as easy as possible to build your own MMORPG with it.

## Installation

### Requirements

* 4GB Memory or higher
* 2 CPUs @ 2GHz or higher
* Ubuntu Server 20.04 x64

It is possible to build the server with 2GB Memory and 1 CPU, but it will be overloaded when you try to run it.

You can get a droplet that meets these requirements on [Digital Ocean](https://www.digitalocean.com/pricing/) for $20/month.

These installation steps assume you are starting with a clean install of Ubuntu Server 20.04 x64.

### Create a new user, give them sudo access and login as them

`adduser --gecos "" anishin`

`usermod -aG sudo anishin`

`exec su - anishin`

### Clone the repository, build the OS dependencies, import the DB and build the code

`git clone https://github.com/anishin-mmorpg/anishin-server.git`

`cd anishin-server`

`sudo ./build.sh os`

`sudo ./build.sh db`

`sudo ./build.sh`

It will take about 2 Hrs to complete the last step.

### Setup the Shard Administration Website for the server

* Go to http://\<server-ip-address\>/setup/

* Leave the defaults and click **Configure** then **Continue**

* There is no need to go any further

### Start the server

`sudo ./run.sh start`

* Press ENTER to launch the services

* Let it run until you see all the services display *is up*

### Verify the server is running properly

* Go to http://\<server-ip-address\>/admin/

* **Login:** admin **Password:** admin

* Click on **Domains > ryzom_open** and then **Shards > open**

* The **State** for all services should say *Online* or *ReadWrite*

### Connect to the server and play Ryzom

You can build the [Anishin Client](https://github.com/anishin-mmorpg/anishin-client) or use the official one by doing the following ... 

* Add the shard's domain to your *hosts* file

* On Windows, this is located at C:\Windows\System32\drivers\etc\hosts

* On Linux and Mac, this is located at /etc/hosts

`<server-ip-address> shard01.ryzomcore.local`

* Add the shard's domain to your *client.cfg*

* On Windows, this is located at %APPDATA%\Ryzom\0\client.cfg

`StartupHost          = "shard01.ryzomcore.local";`

`Application          = { "ryzom_open", "./client_ryzom_r.exe", "./" };`

* Start the client normally and login as the test user

* **Login:** testuser **Password:** testuser

## Security Considerations

This setup is NOT secure in any way. It does crazy things like disabling your firewall and adding sketchy permissions. It is your responsibility to secure the system this runs on! The priority right now is to get a system that actually *works* and is *simple* to build. I will eventually implement security best practices, but that is a long way out.

## Future Plans

I do not plan on keeping the forked code up to date with any of the public repositories. Things are just too incompatible.

We will go our own way.
