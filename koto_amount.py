#!/usr/bin/python
# -*- coding: utf8 -*-

import os.path
import glob
import json

hdir = os.path.expanduser('~')
total=0
cnt=0

fl = sorted(glob.glob(os.path.join(hdir, '.koto/[1-9]*.json')))
for fn in fl:
  subtotal = 0
  subcnt = 0

  f = open(fn, 'r')

  data = json.load(f)
  

  for attr in data:
    subcnt += 1
    subtotal = subtotal + attr.get('amount')

  print '{0}: {1:4d}件: {2:13.8f}'.format(fn, subcnt, subtotal)
  f.close
  total = total + subtotal
  cnt = cnt + subcnt

print "-" * 60
print " " * 22 + u'総件数: {0:4d}件   総合計:{1:13.8f} koto'.format(cnt, total)