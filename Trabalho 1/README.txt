Código feito em Octave, não foi testado no Matlab.

"Entre resistência da carga:" Resistência da carga em ohm. '0' para curto circuito, 'inf' para infinito (circuito aberto).

"Entre tensão da fonte": Entrar '1' ou '2'
 1 - Vs(t) = 2*u(t);
 2 - Vs(t) = u(t) - u(t - Z/(10*uf));
  
u(t) - função degrau
Z = comprimento da linha
uf =  velocidade do sinal
 
"dz = Z/p ,p = " precisão, quanto maior mais preciso, porém mais lento e maior uso de memória

   p 	|Uso de memória | Tempo para calcular a malha	|
   100	|     116 MB	|		 0,2 s		| (não recomendado, baixa precisão)
   500	|     200 MB	|		 1,3 s		|
  1000	|     420 MB	|		 3,6 s		| (recomendado, boa precisão e baixo uso de memória)
  1500	|     800 MB	|		 6.8 s		|
  2000	|    1350 MB	|		10,8 s		|
  2500 	|    2000 MB	|		15,7 s		|
  3000	|    3100 MB	|		21,6 s		| (não recomendado, alto custo e melhoria negligível)	
  
O tempo para apresentar a simulação em forma gráfica gira em torno de 40s a 1min, independentemente da precisão.

O programa gera um gráfico que mostra os valores de tensão e corrente em função da posição na linha de transmissão, 
e uma barra de progresso, que mostra o progresso da simulação e o tempo da simulacao.
