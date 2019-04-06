AXE masternode for docker
===================

Docker image that runs the AXE daemon which can be turned into a masternode with the correct configuration.

This image also runs [sentinel](https://github.com/axerunners/sentinel) (which is required for a masternode to get rewards) every minute as a cron job.

Quick Start
-----------

```bash
docker run \
  -d \
  -p 9937:9337 \
  -v /some/directory:/axe \
  --name=axe \
  axerunners/axe
```

This will create the folder `.axecore` in `/some/directory` with a bare `axe.conf`. You might want to edit the `axe.conf` before running the container because with the bare config file it doesn't do much, it's basically just an empty wallet.

Start as masternode
------------

To start the masternode functionality, edit your axe.conf (should be in /some/directory/.axe/ following the docker run command example above):

```
rpcuser=<SOME LONG RANDOM USER NAME>
rpcpassword=<SOME LONG RANDOM PASSWORD>
rpcallowip=::/0
server=1
logtimestamps=1
maxconnections=256
printtoconsole=1
masternode=1
masternodeaddr=<SERVER IP ADDRESS>:9937
masternodeprivkey=<MASTERNODE PRIVATE KEY>
masternodeblsprivkey=<MASTERNODE BLS SECRET>
```

Where `<SERVER IP ADDRESS>` is the public facing IPv4 address that the masternode will be reachable at.

`<MASTERNODE PRIVATE KEY>` is the private key that you generated earlier (with `axe-cli masternode genkey`).

`<MASTERNODE BLS SECRET>` is the BLS secret that you generated earlier (with `axe-cli bls generate`).
