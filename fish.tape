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

Type "pypi -h"
Enter
Sleep 3s

Type clear
Enter
Sleep 100ms

Type "pypi jax"
Enter
Sleep 3s

Type clear
Enter
Sleep 100ms

Type "pypi -d jax"
Enter
Sleep 2s
PageDown
Sleep 4s

# clear
Hide
Type q
Enter
Sleep 100ms
Type clear
Enter
Sleep 100ms
Show

# chat.fish demo
Type "# chat.fish is my CLI for OpenAI and Perplexity models"
Enter
Sleep 100ms

Type "chat W"
Sleep 100ms
Hide
Type "rite a haiku about Mistral AI en français."
Show
Sleep 100ms
Enter
Sleep 4s

Type clear
Enter
Sleep 100ms

Type "chat -m codellama-34b-instruct W"
Sleep 100ms
Hide
Type "rite a Python password generator in under 15 lines with just the code and nothing else. Wrap in '```py.'"
Show
Sleep 100ms
Enter
Sleep 6s
