#!/bin/bash

# This script is to print C++ codes to a book in the pdf format
# pre-requirement: pdflatex, evince
# input: main.tex, cover.tex (cover and prefix)
# this script is to output a code.tex (each chapter is one C++ file)
# pdflatex main.tex to complie tex and output pdf
# evince is to view the pdf file
# By: Xiaoyang Liu,  xiaoyang.liu@gmail.com
# 12/21/2020

# remove files only if they exist
rm -rf code.tex main.aux main.toc main.pdf main.log main.out *~
# this code is in the folder print_code, so ../ is to find all the files/dictories, filter is cpp and h
for i in $(find ../ -regex ".*\.\(cpp\|h\)")
do
    # for each cpp/head file 
    if test -f $i
    then
	# rename file name, for example $i = ./folder/file_b.cpp
	f="${i:3}"  # remove ../
	f="${f//_/-}" # replace _ with - as Latex chapter doese support _ character
	str="\chapter{" 
	str+=$f
	str+="}"  # join filename and make a chapter as \chatper{filename}
	echo $str >> code.tex 
	echo '\begin{lstlisting}[language=C++]' >> code.tex
	cat $i >> code.tex # output source code into code.tex
	echo '\end{lstlisting}' >> code.tex	
    fi
done

pdflatex main.tex  # compile tex twice to make a correct of table of content
pdflatex main.tex
evince main.pdf & # view pdf
rm -rf main.aux main.toc main.out main.log *~ #clean intermediate files
