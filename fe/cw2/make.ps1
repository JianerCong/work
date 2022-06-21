# Rscript .\data\d.R

pdflatex main
pdflatex main 1> log.txt
Remove-Item out*
