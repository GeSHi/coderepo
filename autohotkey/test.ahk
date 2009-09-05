#IfWinActive
#Persistent
; comment1
/*
multiline comment
msgbox(comment)
*/
  
F2::     ;; hotkey
start:   ;; label
start2:   ; label
  ppm := ppm_new(50, 50, 255)    
  ppm_fill(ppm, 80, 90, 95)      
  msgbox % getPixel(ppm, 1, 1)    
  setPixel(90, 90, 90, ppm, 1, 1)
  msgbox % getPixel(ppm, 1, 1)
  ListVars  ; command
  msgbox % ppm
  return
  
  
  ppm_read(file)
  {
	fileread, ppm, % file
 return ppm
}

::hotstring::
::hot3::
ppm_width(ppm)
{
 regexmatch(ppm, "\R(\d+)\s(\d+)", dim)
 return dim1
}
ppm_height(ppm)
{
 regexmatch(ppm, "\R(\d+)\s(\d+)", dim)
    return dim2
} 

ppm_colors(ppm)
{
regexmatch(ppm, "\R(\d+)\D*\R", colors)  ; \R stands for any
return colors1
}

ppm_data(ppm)
{
pos :=  regexmatch(ppm, "\R(\d+)\D*\R", colors)  ; \R stands for any newline
stringtrimleft, data, ppm, pos + strlen(colors1)
return data
}
ppm_header(ppm)
{
pos :=  regexmatch(ppm, "\R(\d+)\D*\R", colors)  ; \R stands for any newline
stringleft, header, ppm, pos + strlen(colors1)
return header
}

ppm_fill(ByRef ppm, r, g, b)
{
  width := ppm_width(ppm)	
  height := ppm_height(ppm)
  header := ppm_header(ppm)
  headerLength := strlen(header) 
  varsetcapacity(data, width * height, 0)
  loop, % (width * height)
  {
	if r
   numput(r, data, (A_Index - 1) * 3, "uchar")
 if g
   numput(g, data, (A_Index - 1) * 3 + 1, "uchar")
 if b
   numput(b, data, (A_Index - 1) * 3 + 2, "uchar")
}
VarCopy(&ppm + headerLength, &data, width * height)

}

ppm_new(width, height, colors)
{
  header = P6`n%width% %height%`n%colors%`n
  headerLength := strlen(header)
  varsetcapacity(ppm, width * height + headerLength, 1)
  varsetcapacity(data, width * height, 0)
  VarCopy(&ppm, &header, headerLength)
  VarCopy(&ppm + headerLength, &data, width * height)
  return ppm
}

heredoc = 
(
  P6
  # lasdjkf
  87 09
  255
  color data...
)

; Example: Simple image viewer:

Gui, +Resize
Gui, Add, Button, default, &Load New Image
Gui, Add, Radio, ym+5 x+10 vRadio checked, Load &actual size
Gui, Add, Radio, ym+5 x+10, Load to &fit screen
Gui, Add, Pic, xm vPic
Gui, Show
return

ButtonLoadNewImage:
FileSelectFile, file,,, Select an image:, Images (*.gif; *.jpg; *.bmp; *.png; *.tif; *.ico; *.cur; *.ani; *.exe; *.dll)
if file =
    return
Gui, Submit, NoHide ; Save the values of the radio buttons.
if Radio = 1  ; Display image at its actual size.
{
    Width = 0
    Height = 0
}
else ; Second radio is selected: Resize the image to fit the screen.
{
    Width := A_ScreenWidth - 28  ; Minus 28 to allow room for borders and margins inside.
    Height = -1  ; "Keep aspect ratio" seems best.
}
GuiControl,, Pic, *w%width% *h%height% %file%  ; Load the image.
Gui, Show, xCenter y0 AutoSize, %file%  ; Resize the window to match the picture size.
return

GuiClose:
ExitApp
; Example: Simple text editor with menu bar.

; Create the sub-menus for the menu bar:
Menu, FileMenu, Add, &New, FileNew
