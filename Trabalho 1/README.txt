Código feito em Octave, não funciona no Matlab.

"Entre resistência da carga:" Resistência da carga em ohm. '0' para curto circuito, 'inf' para infinito (circuito aberto).

"Entre tensão da fonte": Entrar '1' ou '2'
 1 - Vs(t) = u(t) - u(t - Z/(10*uf));
 2 - Vs(t) = 2*u(t);
  
u(t) - função degrau
Z = comprimento da linha
uf =  velocidade do sinal

O tempo para apresentar a simulação em forma gráfica é de aproximadamente 1min

O programa gera um gráfico que mostra os valores de tensão e corrente em função da posição na linha de transmissão, 
e uma barra de progresso, que mostra o progresso da simulação e o tempo da simulacao.
