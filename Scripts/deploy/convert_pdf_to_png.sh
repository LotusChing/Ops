#!/bin/bash
for pdf in `ls *.pdf`
do
  pdf_name=`echo $pdf | awk -F'.' '{print $1}'`
  [ -f ${pdf_name}.png ] && continue || pdftoppm -png ${pdf} ${pdf_name}
  mv ${pdf_name}-1.png ${pdf_name}.png
done 
