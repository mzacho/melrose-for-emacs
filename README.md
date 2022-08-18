# melrose-for-emacs
Emacs extension for the MIDI programming tool [Melrōse](https://github.com/emicklei/melrose).

The extensions loads `.mel` and `.melrose` files with `melrose-mode` which adds the following bindings to the keymap:

- ("C-c C-e" . #'melrose-eval)
- ("C-c C-p" . #'melrose-eval-and-play)
- ("C-c C-s" . #'melrose-eval-and-stop)
- ("C-c C-k" . #'melrose-kill)
- ("C-c C-i" . #'melrose-eval-and-inspect) (*not implemented*)

Communication with the Melrōse language server is written to the buffer `*melrose*`.

## Installation

First install [melrōse](https://github.com/emicklei/melrose)

Clone repository, add it to your `load-path` and load the extension with

```
(add-to-list 'load-path "/path/to/melrose-for-emacs")
(require 'melrose)
```

## Usage

Start the Melrōse language server by running `melrose` from a terminal prompt. By default it listens on port 8118 on the localhost.

Open any `.mel` or `.melrose` files in Emacs and send requests to the language server. Receive midi in your favorite DAW or MIDI to OSC interface driving your modular rack. dance, go nuts.
