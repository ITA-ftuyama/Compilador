cd ..

echo Chamando Flex
flex Compilador/Lab06.l

echo Chamando Yacc
yacc -v Compilador/Lab06.y

echo Compilando arquivo
gcc y.tab.c main.c yyerror.c -o Lab06 -lfl

echo Compilando programa

./Lab06  < Compilador/Lab06Prog.dat > Compilador/Lab06ProgOutput.dat

	./Lab06 < Compilador/Testes04/Declaracao.dat > Compilador/Testes04/oDeclaracao.dat
	./Lab06 < Compilador/Testes04/Principal.dat > Compilador/Testes04/oPrincipal.dat
	./Lab06 < Compilador/Testes04/Indexada.dat > Compilador/Testes04/oIndexada.dat
	./Lab06 < Compilador/Testes04/Compatibilidade.dat > Compilador/Testes04/oCompatibilidade.dat
	./Lab06 < Compilador/Testes04/Para.dat > Compilador/Testes04/oPara.dat
	./Lab06 < Compilador/Testes04/CallFunc.dat > Compilador/Testes04/oCallFunc.dat
	./Lab06 < Compilador/Testes04/RetornoFunc.dat > Compilador/Testes04/oRetornoFunc.dat

echo Completo
