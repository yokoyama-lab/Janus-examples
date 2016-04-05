all: 
	happy -gca ParC.y
	alex -g LexC.x
	ghc --make TestC.hs -o TestC

doc: DocC.pdf

DocC.pdf: DocC.tex
	pdflatex DocC.tex

clean: 
	-rm -f *.log *.aux *.hi *.o *.dvi
	-rm -f DocC.ps

distclean: clean
	-rm -f DocC.* LexC.* ParC.* LayoutC.* SkelC.* PrintC.* TestC.* AbsC.* TestC ErrM.* SharedString.* ComposOpC.* C.dtd XMLC.* Makefile*
	

