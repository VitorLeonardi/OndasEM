Código feito em Octave, não foi testado no Matlab.

"Entre resistência da carga:" Resistência da carga em ohms ('0' ou maior, 'inf' para infinito).

"Entre tensão da fonte": Entrar '1' ou '2'
 1 - Vs(t) = 2*u(t);
 2 - Vs(t) = u(t) - u(t - Z/(10*uf));
  
u(t) - função degrau
Z = comprimento da linha
uf =  velocidade do sinal
 
"dz = Z/p ,p = " precisão, quanto maior mais preciso, porém mais lento e maior uso de memória

   p 	|Uso de memória | Tempo para finalizar 
   500	|     200 MB	|	10 s
  1000	|     420 MB	|	20 s
  1500	|     800 MB	|	34 s
  2000	|    1350 MB	|	51 s
  2500 	|    2000 MB	|	67 s
  3000	|    3100 MB	|	82 s 

O programa gera um gráfico que mostra os valores de tensão e corrente em função da posição na linha de transmissão, 
e uma barra de progresso, que mostra o progresso da simulação.