# Git

Most settings are in [`.config/git/config`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/git/config). The rest go in `~/.gitconfig`:

```properties
[user]
	name = <your_name>
	email = <your_email>
	signingkey = <your_key>
[commit]
	gpgsign = true
```

See the [`git config`](https://git-scm.com/docs/git-config#FILES) docs for how the files are resolved.

## Authenticating

Create `~/.git-credentials` with:

```
https://<your_username>:<your_token>@github.com
```
