@echo off
echo ######################################
echo #                                    #
echo #    Interpretador COMP-ITA 2016     #
echo #                                    #
echo ######################################

cd ..

echo Chamando Flex
flex Compilador/Lab06.l

echo Chamando Yacc
yacc -v Compilador/Lab06.y

echo.
echo Compilando arquivo
gcc y.tab.c main.c yyerror.c -o Lab06 -lfl

echo.
echo Compilando programa

Lab06  < Compilador/Lab06Prog.dat > Compilador/Lab06ProgOutput.dat
Lab06  < Compilador/Lab06Teste.dat > Compilador/Lab06TesteOutput.dat

 goto TestesSemanticos
	Lab06 < Compilador/Testes04/Declaracao.dat > Compilador/Testes04/oDeclaracao.dat
	Lab06 < Compilador/Testes04/Principal.dat > Compilador/Testes04/oPrincipal.dat
	Lab06 < Compilador/Testes04/Indexada.dat > Compilador/Testes04/oIndexada.dat
	Lab06 < Compilador/Testes04/Compatibilidade.dat > Compilador/Testes04/oCompatibilidade.dat
	Lab06 < Compilador/Testes04/Para.dat > Compilador/Testes04/oPara.dat
	Lab06 < Compilador/Testes04/CallFunc.dat > Compilador/Testes04/oCallFunc.dat
	Lab06 < Compilador/Testes04/RetornoFunc.dat > Compilador/Testes04/oRetornoFunc.dat
:TestesSemanticos

goto TestesCodigoIntermediario
	Lab06  < Compilador/Testes05/Lab06Teste.dat > Compilador/Testes05/Lab06TesteOutput.dat
	Lab06  < Compilador/Testes05/Lab06TesteSlides.dat > Compilador/Testes05/Lab06TesteSlidesOutput.dat
:TestesCodigoIntermediario

echo Completo
cd Compilador
pause