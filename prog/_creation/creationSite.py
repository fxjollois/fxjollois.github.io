# -*- coding: utf8 -*-

# A exécuter avec : exec(open('creationSite.py').read())

# librairies à importer
import markdown
import re
import os
import shutil

print ( "-----" )

# transformation du index.md principal en html
pageMd = open("../index.md", "r").read()
pageHtml = markdown.markdown(pageMd, extensions=['markdown.extensions.codehilite'])
startHtml = open("start.html", "r").read()
endHtml = open("end.html", "r").read()
open("../index.html", "w").write(startHtml + pageHtml + endHtml)

print ( "\nSite complètement créé." )

print ( "-----" )


