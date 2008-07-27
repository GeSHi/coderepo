#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Project       FreeImagePy
# file name:    utils.py
#
# $Id $
#

# DESCRIPTION
# FreeImage python bind
#
# Developer:
# Michele Petrazzo <michele.petrazzo@unipex.it>
#
# History : (see history.txt for more info)
# creation: 08/2005 - Michele Petrazzo
#
# License:
#         GNU General Public License (GPL)
#         FreeImage Public License (FIPL)
#         For more info see LICENSE.txt
#
# Copyright (C) 2005  Unipex s.r.l.,  All Rights Reserved.
# Via Vittorio Veneto 83/A
# 33050 Gonars (UD) - Italy
# tel. +39 0432 931511 - fax +39 0432 931378
# www.unipex.it - michele.petrazzo@unipex.it
#

from FreeImagePy import *
import imp

USE_PIL, USE_WX = True, True

try:
    imp.find_module("Image")
except ImportError:
    USE_PIL = False

try:
    imp.find_module("wx")
except ImportError:
    USE_WX = False

if USE_PIL:
    def convertToPil(image):
        """
        """
        import Image as PIL
        cu = image.getBPP()
        if not cu in COL_To_PIL.keys():
            raise ValueError, "Color not supported in convertToPil, %s" % cu

        w,h = image.size
        pil = PIL.new(COL_To_PIL[cu], (w, h))
        pil.fromstring(image.getBuffer())
        del PIL
        return pil

else:
    def convertToPil(self, *args,**kw):
        print "PIL not installed, please install it and retry"
        return None

if USE_WX:
    def convertToWx(dib):
        import wx
        w,h = dib.size
        image = wx.EmptyImage(w,h)
        new_image = dib.clone()
        new_image.bpp = 24
        b = new_image.getBuffer()[: w*h*3]
        image.SetData( b )
        del wx
        return image
else:
    def convertToWx(self, *args,**kw):
        print "wx not installed, please install it and retry"
        return None

def getParametersFromExt(fileName, FIF=None):
    # Try to understand the type from extension
    ext = None
    if "." in fileName and not FIF:
        ext = os.path.splitext(fileName)[1].replace(".", "")
        #control for the ambigous extensions
        if ext.startswith("tif") and not ext.startswith("tiff"):
            ext = "tiff" + ext[3:]
        elif ext.startswith("jpg"):
            ext = "jpeg" + ext[3:]

    if FIF == None and ext in extToType.keys():
        FIF, flags, ext = extToType[ext]
        fileName = os.path.splitext(fileName)[0] + ext
    elif FIF in extToType.keys():
        FIF, flags, ext = extToType[FIF]
        if not fileName.endswith(ext):
            fileName += ext
    else:
        keyType = filter(lambda x: extToType[x][0] == FIF, extToType)
        if keyType:
            FIF, flags, ext = extToType[ keyType[0] ]
        else:
            return None, None, "no_ext", fileName

    return FIF, ext, flags, fileName

