Rl = inputdlg('Entre resistência da carga: ','Sample',[1 5]);
m = inputdlg('Entre tensão da fonte','Sample',[1 5]);#modo Vs m=1,2
Rl = str2num(Rl{1});#resistencia da carga
m = str2num(m{1});#modo da fonte de tensão (1 ou 2)

#funcao para tensao da fonte
function y = Vs(t,m,uf,Z)
  if (m == 2);
    y = 2;
  elseif (t < Z/(10*uf))
    y = 1;
  else
    y = 0;
  endif
endfunction

Rs = 75; #resistencia fonte
Z0 = 50 ; #resistencia da linha
c = 3e+8; #velocidade da luz
uf = 0.9*c; #velocidade de propagacao do sinal
#valores acima na descricao do projeto 

Z = 10;  # comprimento da linha
T = 8*Z/uf;  #tempo limite, na decricao do projeto 

L = Z0/uf; #Z0 = L* Uf
C = L/Z0**2; #Z0 = sqrt(L/C)
#L e C sao derivados de uf e Z0

dz = Z/10000;
z = -Z:dz:0;
dt = dz/(1.2*uf); # dt < dz/uf
t = 0:dt:T;
Lz = length(z);
Lt = length(t);
i = v = zeros( 2 , Lz ); #malha

k1 = 0.5*(Rs*C*dz/dt - 1);
k2 = 0.5*(Rs*C*dz/dt + 1);

#{
i(n,k) -> i(n,k+1/2)
v(n,k) -> v(n+1/2,k)
#}

figure('Name',['Rl = ',num2str(Rl),', m = ', num2str(m)],'NumberTitle','off');
V = v(1,:);
I = i(1,:);
subplot(2,1,1);
plot (z, V,'ydatasource','V');
title('tensão');
xlabel("z (m)");
ylabel("v (V)");
axis([-Z 0 -0.6/m 1.1*m]);
subplot(2,1,2);
plot (z, I,'ydatasource','I');
title('corrente');
xlabel("z (m)");
ylabel("i (A)");
axis([-Z 0 -0.012/m 0.02*m]);
w = waitbar(0,'t = 0s');

M = 150;
for n = 2:Lt-1
  #condicao de fronteira z = -Z (fonte)
  v(2,1) = (k1/k2)*v(1,1) - (Rs*i(1,1) - (Vs((n+1/2)*dt,m,uf,Z) + Vs((n-1/2)*dt,m,uf,Z))/2)/k2;
  
  #equacao de update tensão
  #codigo vetorizado, linha sem perdas
  v(2,2:Lz-1) = v(1,2:Lz-1) - dt*(i(1,2:Lz-1) - i(1,1:Lz-2))/(C*dz);
  
  #condicao de fronteira z = 0 (carga)
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
  #equacao de update corrente
  i(2,1:Lz-1) = i(1,1:Lz-1) - dt*(v(2,2:Lz)-v(2,1:Lz-1))/(L*dz);
  
  v(1,:) = v(2,:);
  i(1,:) = i(2,:);
  
  if ( mod(n,M) == 0) 
    I = i(1,:);
    V = v(1,:);
    if (mod(n,10*M) == 0)
    s = num2str(n*dt);
    waitbar(n/Lt,w,['t = ',s,'s']);
    endif
    refreshdata
    drawnow
  endif
  
endfor
clear
