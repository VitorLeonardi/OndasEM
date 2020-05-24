Código feito em Octave, não foi testado no Matlab.

"Entre resistência da carga:" Resistência da carga em ohms ('0' ou maior, 'inf' para infinito).

"Entre tensão da fonte": Entrar '1' ou '2'
 1 - Vs(t) = 2*u(t);
 2 - Vs(t) = u(t) - u(t - Z/(10*uf));
  
u(t) - função degrau
Z = comprimento da linha
uf =  velocidade do sinal
 
"dz = Z/p ,p = " precisão, quanto maior mais preciso, porém mais lento e maior uso de memória

   p 	|Uso de memória | Tempo para calcular a malha	| Tempo pra simulação ( gráfico )
   500	|     200 MB	|		 1,3 s					|		31 s
  1000	|     420 MB	|		 3,6 s					|		33 s
  1500	|     800 MB	|		 6.8 s					|		35 s
  2000	|    1350 MB	|		10,8 s					|		37 s
  2500 	|    2000 MB	|		15,7 s					|		37 s
  3000	|    3100 MB	|		21,6 s					|		41 s
  

O programa gera um gráfico que mostra os valores de tensão e corrente em função da posição na linha de transmissão, 
e uma barra de progresso, que mostra o progresso da simulação.