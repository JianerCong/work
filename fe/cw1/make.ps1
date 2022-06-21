# Rscript .\data\d.R

Copy-Item -Path C:\Users\congj\Desktop\seismic_gala\data\tex\out* -Destination .
Copy-Item -Path C:\Users\congj\Desktop\seismic_gala\output\gala.png -Destination .\fig
pdflatex main
pdflatex main 1> log.txt
Remove-Item out*
