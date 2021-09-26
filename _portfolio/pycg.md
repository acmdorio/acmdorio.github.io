---
title: "PyCG"
excerpt: "Interactive Graphical System"
last_modified_at: 2021-10-02
header:
  teaser: https://user-images.githubusercontent.com/27034173/131598578-02114b0e-6d33-455b-823b-3dfd36b59479.png
tags:
  - algorithms
  - Computer Graphics
---

This is a Interactive Graphical System made as a UFSC Computer Graphics (INE5420) project using [Qt for Python][PySide2].
Source code is available on [GitHub](https://github.com/baioc/PyCG).

![3D](https://user-images.githubusercontent.com/27034173/131598578-02114b0e-6d33-455b-823b-3dfd36b59479.png)

<img src="https://user-images.githubusercontent.com/27034173/131594230-6012ef29-01fb-44db-8ba4-2d97f00ff00d.png" width="45%">
<img src="https://user-images.githubusercontent.com/27034173/131594235-0bc0321c-598d-4bb9-9959-6913577005d6.png" width="45%">
{: .text-center}


## Installation

### Use

1. Download and uncompress the [latest **release**](https://github.com/RamAddict/INE5420-CG/releases/latest) archive.
2. Install dependencies: `pip install -r requirements.txt --user`
3. Execute the application: `python3 pycg/app.py`<br/>
    Note: you may optionally pass in [OBJ] files to be loaded on startup.

### Dev

Run these to setup and test a development environment:

```shell
$ # system-specific install of pyside2-uic
$ python -m venv venv
$ source venv/bin/activate
(venv) $ pip install -r requirements.txt
(venv) $ pip install pytest
(venv) $ make clean test run
```


[PySide2]: https://doc.qt.io/qtforpython-5/api.html
[OBJ]: http://www.martinreddy.net/gfx/3d/OBJ.spec
