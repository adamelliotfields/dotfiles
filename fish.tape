# output file name
Output fish.gif

# sizing
Set Width 830
Set Height 467
Set WindowBar Colorful
Set Theme "GitHub Dark"

# font
Set FontFamily "CaskaydiaCove Nerd Font"
Set FontSize 16

# setup
Hide
Type fish
Enter
Sleep 1s
Type clear
Enter
Sleep 100ms
Show

# intro
Type "# fish allows you to customize your shell with functions"
Enter
Sleep 100ms

# pypi.fish demo
Type "# for example, pypi.fish let's you search PyPI"
Enter
Sleep 100ms

Type "pypi tensorboard"
Enter
Sleep 2s

# clear
Hide
Type "clear"
Enter
Sleep 100ms
Show

# file.fish demo
Type "# file.fish is a file.io CLI"
Enter
Sleep 100ms

Type "echo 'Hello, GitHub!' > hello.txt"
Enter
Sleep 100ms

Type "set url (file hello.txt)"
Enter
Sleep 1s

Type "echo $url"
Enter
Sleep 2s

# clear
Hide
Type "clear"
Enter
Sleep 100ms
Show

Type "# normally you'd download on another computer..."
Enter
Sleep 100ms

Type "file $url -o github.txt"
Enter
Sleep 500ms

Type "cat github.txt"
Enter
Sleep 2s

# cleanup and clear
Hide
Type "rm -f hello.txt github.txt"
Enter
Sleep 100ms
Type "clear"
Enter
Sleep 100ms
Show

# chat.fish demo
Type "# chat.fish is my CLI for OpenAI and Perplexity models"
Enter
Sleep 100ms

Type "chat Write a haiku about Mistral AI en français."
Enter
Sleep 4s

Type "chat -m codellama-34b-instruct Write a Python password generator in under 15 lines with just the code and nothing else. Wrap in '```py.'"
Enter
Sleep 6s
