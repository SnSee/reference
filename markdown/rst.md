
# rst

编译 rst 文档

```sh
sudo apt install sphinx
# 在当前目录创建 conf.py
# 缺少什么 module 就安装
sphinx-build -b html -c . /home/ycd/open_source/mesa-24.2.2/docs ./build/html
```

```py
# conf.py
import sphinx_rtd_theme
html_theme = "sphinx_rtd_theme"
html_theme_path = [sphinx_rtd_theme.get_html_theme_path()]

# Use a built-in Pygments style
# 查看支持的主题样式: pygmentize -L styles
pygments_style = 'default'
```
