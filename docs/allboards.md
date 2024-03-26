## All Boards

### Description

`All Boards` page shows list of All Boards user currently has access to.
It is similar to `All Boards` page of WeKan Open Source kanban https://wekan.github.io

### Why

1. Minimal code
  - https://danluu.com/web-bloat/
  - https://news.ycombinator.com/item?id=39729057
2. Web pages of apps that work at all browsers:
  - Modern browsers.
  - Maintained browsers, like Amiga IBrowse, Netsurf.
  - Text browsers, like ELinks, w3m.
  - Legacy browsers, like IE5, Netscape.
3. I'm creating a new web framework, with newest tech:
  - https://github.com/wekan/wekanstudio

### Bugs

- Button HTML does not work in IE3. So maybe it only works at IE5 or newer. https://caniuse.com/?search=button

### Steps of Font Awesome to GIF

1. I converted some Font Awesome icons https://fontawesome.com/v4/icons/ to PNG at https://fa2png.app
2. With GIMP, I converted PNG to GIF. GIF files are smaller than PNG.
3. I added some of those icons inside of HTML buttons.
4. I used KompoZer https://sourceforge.net/projects/kompozer/files/current/0.8b3/ to create UI layout with tables, and then cleaned up that HTML.
5. I can modified GIF files with GIMP, for example rotating image 90 decrees clockwise.
   That kind of icon did not exist previously at Font Awesome.
   This is about getting back ability to modify icons easily.
6. I only use those GIF icons visible at webpage, resulting to smaller size, faster loading pages.
   No need to have all of Font Awesome.
7. Profit, because of faster loader pages, and smaller bandwidth bills.

### Alternatives to GIF

- Unicode. But it does not show correctly at some browsers.
- ASCII art.

### Demo

- GIF icons: https://wekanstudio.github.io/allboards-gif.html
- Unicode icons: https://wekanstudio.github.io/allboards-unicode.html

### Code

https://github.com/wekanstudio/wekanstudio.github.io/blob/main/allboards.html

### License

MIT.
