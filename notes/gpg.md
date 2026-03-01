# GPG

_GNU Privacy Guard_ is the de facto implementation of the OpenPGP (Pretty Good Privacy) standard. It is used to sign commits in Git.

## Generate a key

```sh
# install gnupg if necessary
sudo apt install -y gnupg

# you'll be asked a few questions, respond with:
#   1. RSA and RSA
#   2. 4096
#   3. 0 (does not expire)
# then enter your full name and email address; passphrase can be left empty
gpg --full-generate-key

# this command prints the ID of the key associated with your email address
gpg --list-keys --with-colons $YOUR_EMAIL | tr ' ' '\n' | grep '^pub' | cut -d':' -f5

# the armor flag outputs ASCII (text) instead of binary ("ASCII armor")
gpg --armor --comment $YOUR_EMAIL --export $YOUR_EMAIL > your.pub.key
gpg --armor --comment $YOUR_EMAIL --export-secret-keys $YOUR_EMAIL > your.sec.key
```

## Import a key

If you just made the key, then it is already in the keychain of the computer you made it on. Here's how to import the secret key everywhere else:

```sh
cat your.sec.key | gpg --import
```

Now you have to _trust_ the key so you can sign with it:

```sh
# get the 16-digit key ID again
YOUR_KEY=$(gpg --list-keys --with-colons $YOUR_EMAIL | tr ' ' '\n' | grep '^pub' | cut -d':' -f5)

# enter the following:
#   1. trust (type out the word "trust")
#   2. 5
#   3. y
#   4. quit
gpg --edit-key $YOUR_KEY
```

## Sign commits

Put this in `~/.gitconfig`:

```properties
[commit]
	gpgsign = true
```

Finally, you need to let GitHub know about your key. You can do it through the website or `gh` if you have the **GPG scope** on your token.

```sh
gh gpg-key add /path/to/your.pub.key
```

## Windows

The steps are similar to Linux, but you need to install GnuPG with WinGet:

```pwsh
winget install -s winget --id gnupg.gnupg
```

And get the key ID with PowerShell:

```pwsh
$yourKey = gpg --list-keys --with-colons $yourEmail |
Where-Object { $_.StartsWith('pub:') } |
ForEach-Object { ($_ -split ':')[4] }
```

Then add a Task Scheduler program that runs at login to start the GPG agent:

```pwsh
powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $env:Path=(Join-Path $env:ProgramFiles 'GnuPG\bin') + ';' + $env:Path; gpgconf --launch keyboxd; gpg-connect-agent /bye;"
```
