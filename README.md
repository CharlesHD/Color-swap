# Usage
Small tool for doing a pixel color swap on all images from a directory.

``` bash
.\color-swap swap.bmp imagesDir
```

swap.bmp must be a two row image, each pixel on the first row will be replaced by corresponding pixel on the second row.

# Installation
With stack :

``` bash
stack build
stack install \\ will copy the binary in stack path
```
Stack path on linux is something like `~/.local/bin/`
