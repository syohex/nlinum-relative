[![Built with Spacemacs](https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg)](http://github.com/syl20bnr/spacemacs)
[![License (GPL version 2)](https://img.shields.io/badge/license-GNU%20GPL%20version%202-blue.svg?style=flat-square)](http://opensource.org/licenses/GPL-2.0)

# nlinum-relative
Emacs relative line number besed on nlinum-mode

# Preview
![nlinum-relative](https://cloud.githubusercontent.com/assets/5436704/15206639/51137398-1853-11e6-824c-76595bc40d55.gif)

# Usage

``` lisp
(require 'nlinum-relative)
(nlinum-relative-setup-evil) ;; setup for evil
(add-hook 'prog-mode-hook 'nlinum-relative-mode)
(setq nlinum-relative-redisplay-delay 0.1) ;; delay
(setq nlinum-relative-current-symbol "->") ;; or "" for current line number
```

# Spaecmacs

This package is still not available at MELPA for now. You can install it by 

```lisp
;; add into packages
(nlinum-relative :location (recipe
                                :fetcher github
                                :repo "CodeFalling/nlinum-relative"
                                ))
                                
(use-package nlinum-relative
    :config
    ;; something else you want
    (nlinum-relative-setup-evil)
    (add-hook 'prog-mode-hook 'nlinum-relative-mode))
```

# Related

- [coldnew/linum-relative: display relative line number in the left margin in emacs](https://github.com/coldnew/linum-relative)

  Some code from here

- [GNU ELPA - nlinum](https://elpa.gnu.org/packages/nlinum.html)

  Based on this
