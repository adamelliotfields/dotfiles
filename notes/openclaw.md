# Openclaw

## Packages

Add Node.js PPA:
```sh
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
```

Install Apt packages:
```sh
apt install -y build-essential file ffmpeg imagemagick jq nodejs python3-pip
```

Run if you're using a storage volume for your `.openclaw` state directory:
```sh
# install hcloud and run `hcloud context create --token-from-env openclaw` first
volume_id=$(hcloud volume list -o json | jq '.[0].id')
export OPENCLAW_STATE_DIR=/mnt/HC_Volume_${volume_id}/.openclaw
```

Install Homebrew (Linuxbrew):
```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> /root/.bashrc
source ~/.bashrc
```

Install `gog`:
```sh
# follow instructions in gogcli readme to create client secret
brew install gog
gog auth credentials /path/to/client_secret.json  # creates ~/.config/gogcli/credentials.json
gog auth add <your_bot_email>@gmail.com --manual  # will prompt for redirect URL
```

Install openclaw and qmd:
```sh
mkdir -p /root/.local/bin
source /root/.profile  # adds ~/.local/bin to PATH
npm config set prefix /root/.local  # creates ~/.npmrc
npm i -g @tobilu/qmd@latest
npm i -g openclaw@latest
```

## Environment Variables

Create `.env` in your OpenClaw state directory:
```sh
BRAVE_API_KEY=<your_brave_key>
GOG_ACCOUNT=<your_bot_email>@gmail.com
GOG_KEYRING_PASSWORD=<whatever_you_want>
HCLOUD_TOKEN=<your_hcloud_token>
OPENCLAW_STATE_DIR=/mnt/HC_Volume_<volume_id>/.openclaw  # if using block storage
TELEGRAM_BOT_TOKEN=<your_bot_token>
```

Add this to `/root/.bashrc` to expose OpenClaw environment variables:
```sh
# change state folder if not using block storage
export OPENCLAW_STATE_DIR=/mnt/HC_Volume_${volume_id}/.openclaw

if [ -f "$OPENCLAW_STATE_DIR/.env" ] ; then
  while IFS='=' read -r key value || [ -n "$key" ] ; do
    [[ -z $key || $key =~ ^# ]] && continue
    export "$key=$value"
  done < "$OPENCLAW_STATE_DIR/.env"
fi
```

## OpenAI Codex

You have to enable "Device code authorization for Codex" at <https://chatgpt.com/#settings/Security> first.

After authenticating, your tokens are stored in `$OPENCLAW_STATE_DIR/agents/main/agent/{auth,auth-profile}.json`.

Run `openclaw models status` to check the status of your OAuth token.

## OpenClaw

Run OpenClaw gateway onboarding:
```sh
openclaw onboard
```

Use the following initial configuration:
- Onboarding mode: `Manual`
- Workspace: `/mnt/HC_Volume_${volume_id}/.openclaw/workspace`
- Model provider: `OpenAI`
- Default model: `openai-codex/gpt-5.3-codex`
- Gateway port: `18789`
- Gateway bind: `Loopback`
- Gateway auth: `Token`
- Tailscale mode: `Off` (prefer running Tailscale independently)

## Tailscale

Install Tailscale:

> You need to enable Tailscale Serve first: https://tailscale.com/docs/features/tailscale-serve

```sh
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up  # authenticate via link
```

Now serve the gateway as a daemon:
```sh
tailscale serve --bg 18789
```

The Tailscale Serve URL for your server will look like `https://<host>.<tailnet>.ts.net`. Add it to the `gateway.controlUi.allowedOrigins` array in `openclaw.json`. Also make sure `gateway.trustedProxies` includes `127.0.0.1`.

## Gateway Control UI

OpenClaw should refresh when it detects the config change. You can go to the gateway URL now.

You'll get an error that you need to paste the gateway token in `/overview`. You can print it with:
```sh
cat "$OPENCLAW_STATE_DIR/openclaw.json" | jq -r '.gateway.auth.token'
```

Then press the `Connect` button. Now the error will say you need to pair the device.

Back in the terminal, switch to `openclaw` and approve:
```sh
openclaw devices list
openclaw devices approve <request_id>  # from list command
```
