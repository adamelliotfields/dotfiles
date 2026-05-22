# Tailscale

Install and run the daemon:

```sh
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up  # authenticate via link
```

## SSH

You can optionally use Tailscale for SSH authentication when connecting on your [Tailnet](https://tailscale.com/docs/concepts/tailnet).

```sh
# when provisioning a new machine
tailscale up --ssh

# when configuring an existing machine
tailscale set --ssh
```

## Serve

You can expose a running service on a machine within your Tailnet using `serve`. To expose to the public internet, see [`funnel`](https://tailscale.com/docs/reference/tailscale-cli/funnel).

First, enable [serve](https://tailscale.com/docs/features/tailscale-serve).

Then, serve the app:

```sh
tailscale serve --bg <port>
```

The Tailscale Serve URL for your server will look like `https://<host>.<tailnet>.ts.net`. Tailscale provisions a certificate and terminates TLS for you.

You can pass `--http=<port>` to serve over insecure HTTP or `--https=<port>` to serve over a different HTTPS port.
