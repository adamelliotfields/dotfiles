# UFW

See the [manpage](https://manpages.ubuntu.com/manpages/man8/ufw.8.html) and [How to Set Up a Firewall with UFW on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu).

```sh
ufw default deny incoming
ufw default allow outgoing
```

To allow incoming traffic on a specific port, use:

```sh
ufw allow 22  # defaults to both TCP and UDP
ufw enable
```

You can also specify a range of ports:

```sh
# port ranges require the protocol to be specified
ufw allow 8000:9000/tcp
ufw allow 8000:9000/udp
```

To ban an IP if they try to connect 6 times in 30 seconds:

```sh
ufw limit 22/tcp
```

To allow all connections from a subnet to a specific port:

```sh
# to any means "all network interfaces"
ufw allow from 123.456.789.0/24 to any port 80 proto tcp
```

To delete a rule:

```sh
ufw delete allow 22/tcp
```

Use `status` to see the current rules, `disable` to turn off the firewall, and `reset` to start over.
