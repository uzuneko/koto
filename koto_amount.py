#!/usr/bin/python
# -*- coding: utf8 -*-

import os.path
import glob
import json
import datetime

hdir = os.path.expanduser('~')
total=0
cnt=0

fl = sorted(glob.glob(os.path.join(hdir, '.koto/[1-9]*.json')))
for fp in fl:
  subtotal = 0
  subcnt = 0

  fn, ext = os.path.splitext(os.path.basename(fp))
  dt = datetime.datetime.fromtimestamp(float(fn))

  f = open(fp, 'r')
  data = json.load(f)
  for attr in data:
    subcnt += 1
    subtotal = subtotal + attr.get('amount')

  print '{0}: {1:4d}件: {2:13.8f}'.format(dt, subcnt, subtotal)
  f.close
  total = total + subtotal
  cnt = cnt + subcnt

print "-" * 43
print " " * 21 + '{0:4d}件: {1:13.8f} koto'.format(cnt, total)