all:
	pdflatex main
	# bibtex main
	pdflatex main > /dev/null
	# pdflatex main > /dev/null
	rm *.aux *.log
	echo done


clean:
	rm *.pdf *.bbl *.blg


# Local Variables:
# mode: makefile
# End:
