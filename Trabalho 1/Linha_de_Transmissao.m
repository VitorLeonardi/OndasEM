Rl = inputdlg('Entre resistência da carga: ','Sample',[1 5]);
m = inputdlg('Entre tensão da fonte','Sample',[1 5]);
Rl = str2num(Rl{1}); #resistência da carga
m = str2num(m{1}); #modo da fonte de tensão (1 ou 2)

#qualquer valor diferente de 1 ou 2 é considerado 2
if (m != 1 && m != 2)
  m = 2;
endif

#função para tensão da fonte
function y = Vs(t,m,uf,Z)
  if (m == 2);
    y = 2;
  elseif (t < Z/(10*uf))
    y = 1;
  else
    y = 0;
  endif
endfunction

Rs = 75; #resistência fonte
Z0 = 50 ; #resistência da linha
c = 3e+8; #velocidade da luz
uf = 0.9*c; #velocidade de propagação do sinal
#valores acima na descrição do projeto 

Z = 10;  # comprimento da linha
T = 10*Z/uf;  #tempo limite, na decrição do projeto 

L = Z0/uf; #Z0 = L* Uf
C = L/Z0**2; #Z0 = sqrt(L/C)
#L e C são derivados de uf e Z0

dz = Z/1e+4;
z = -Z:dz:0;
dt = dz/(1.2*uf); # dt < dz/uf
t = 0:dt:T;
Lz = length(z);
Lt = length(t);
i = v = zeros( 2 , Lz );

k1 = 0.5*(Rs*C*dz/dt - 1);
k2 = 0.5*(Rs*C*dz/dt + 1);

#cria o gráfico
figure('Name',['Rl = ',num2str(Rl),', m = ', num2str(m)],'NumberTitle','off');
V = v(1,:);
I = i(1,:);
subplot(2,1,1);
plot (z, V,'ydatasource','V');
title('Tensão');
xlabel("z (m)");
ylabel("v (V)");
axis([-Z 0 -0.6/m 1.1*m]);
subplot(2,1,2);
plot (z, I,'ydatasource','I');
title('Corrente');
xlabel("z (m)");
ylabel("i (A)");
axis([-Z 0 -0.012/m 0.02*m]);
w = waitbar(0,'t = 0s');


for n = 2:Lt-1
  #condição de fronteira z = -Z (fonte)
  v(2,1) = (k1/k2)*v(1,1) - (Rs*i(1,1) - (Vs((n+1/2)*dt,m,uf,Z) + Vs((n-1/2)*dt,m,uf,Z))/2)/k2;
  
  #equação de update tensão, linha sem perdas
  v(2,2:Lz-1) = v(1,2:Lz-1) - dt*(i(1,2:Lz-1) - i(1,1:Lz-2))/(C*dz);
  
  #condição de fronteira z = 0 (carga)
  if (Rl == 0)
    v(2,Lz) = 0;
    i(2,Lz) = i(2,Lz-1);
  elseif (Rl == inf)
    v(2,Lz) = v(2,Lz-1);
    i(2,Lz) = 0;
  else
    v(2,Lz) = (k1/k2)*v(1,Lz) + Rl*i(1,Lz-1)/k2;
    i(2,Lz) = v(2,Lz)/Rl;
  endif  
  
  #equação de update corrente, linha sem perdas
  i(2,1:Lz-1) = i(1,1:Lz-1) - dt*(v(2,2:Lz)-v(2,1:Lz-1))/(L*dz);
  
  v(1,:) = v(2,:);
  i(1,:) = i(2,:);
  
  #atualiza o gráfico, 1 em cada 100 iterações, grande aumento em performance.
  if ( mod(n,100) == 0) 
    I = i(1,:);
    V = v(1,:);
    if (mod(n,5*100) == 0)
    s = num2str(n*dt);
    waitbar(n/Lt,w,['t = ',s,'s']);
    endif
    refreshdata
    drawnow
  endif
  
endfor
clear
