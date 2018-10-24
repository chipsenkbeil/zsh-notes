# TODO

## Investigate

- Using __zsh/curses__ module to provide a friendly interface

    - Using `stty size` to read the width and height of the terminal

        local stty_out=$( stty size )
        term_height="${stty_out% *}"
        term_width="${stty_out#* }"

    - Check out [this link](https://github.com/psprint/zsh-navigation-tools)
      for examples of using the __zsh/curses__ module

## Implement

Nothing for now!
