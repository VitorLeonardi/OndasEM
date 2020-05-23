Rl = [inf,0,100]; #resistencia da carga
#funcoes para tensao da fonte
function y = Vs(t,m,uf,l)
  if (m == 1);
    y = 2;
  elseif (t < l/(10*uf))
    y = 1;# valor p teste
  else
    y = 0;
  endif
endfunction


RL = Rl(2);# RL = Rl(1),Rl(2),Rl(3)
m = 1;#modo Vs m=1,2
#


Rs = 75; #resistencia fonte
Z0 = 50 ; #resistencia da linha
c = 3e+8; #velocidade da luz
uf = 0.9*c; #velocidade de propagacao do sinal
#valores acima na descricao do projeto 

l = 10;  # comprimento da linha, valor p teste
T = 10*l/uf;  #tempo limite, na decricao do projeto 

L = Z0/uf; #Z0 = L* Uf
C = L/Z0**2; #Z0 = sqrt(L/C)
#L e C sao derivados de uf e Z0

dz = l/2500; #valor p teste
z = -l:dz:0;

dt = dz/(2*uf); #valor p teste, dt<dz/uf
t = 0:dt:T;
Lz = length(z)
Lt = length(t)
i = v = zeros( Lt , Lz );

k1 = 0.5*(Rs*C*dz/dt - 1);
k2 = 0.5*(Rs*C*dz/dt + 1);

#{
i(n,k) -> i(n,k+1/2)
v(n,k) -> v(n+1/2   ,k)
#}

#tic toc mede o tempo gasto

tic 
for n = 2:Lt
  v(n,1) = (k1/k2)*v(n-1,1) - (Rs*i(n,1) - (Vs((n+1/2)*dt,m,uf,l) + Vs((n-1/2)*dt,m,uf,l))/2)/k2;
  #equacao de update
  #codigo vetorizado, muito mais rapido, linha sem perdas ,Gedney p43
  v(n,2:Lz) = v(n-1,2:Lz) - dt*(i(n,2:Lz) - i(n,1:Lz-1))/(C*dz);
  i(n+1,1:Lz-1) = i(n,1:Lz-1) - dt*(v(n,2:Lz)-v(n,1:Lz-1))/(L*dz);
  #condicoes de fronteira
  #v(n,Lz) = (k1/k2)*v(n-1,Lz) + Rl(3)*i(n,Lz-1)/k2;
  #v(n,Lz) = v(n-1,Lz) - 2*dt*(i(n,Lz) - i(n,Lz-1))/(C*dz);
  #i(n+1,Lz) = i(n+1,Lz-1) e v(n,Lz) = 0 pra Rl = 0
  if (RL == 0)
    v(n,Lz) = 0;
    i(n+1,Lz) = i(n+1,Lz-1);
  else
    i(n+1,Lz) = v(n,Lz)/RL;
  endif
endfor
toc

figure('Name',['Rl = ',num2str(RL),', m = ', num2str(m)],'NumberTitle','off');
V = v(1,:);
I = i(1,:);
subplot(2,1,1);
plot (z, V,'ydatasource','V');
title('tensão');
xlabel("z (m)");
ylabel("v (V)");
axis([-l 0 min(min(v)) max(max(v))]);
subplot(2,1,2);
plot (z, I,'ydatasource','I');
title('corrente');
xlabel("z (m)");
ylabel("i (A)");
axis([-l 0 min(min(i)) max(max(i))]);
w = waitbar(0,'t = 0s');

tic
M = 25;#valor p teste
for n = 1:Lt/M#Lt/M para plotar 1 a cada M tempos,x = v(M*n,:),y = i(M*n,:) 
  I = i(M*n,:);
  V = v(M*n,:);
  if (mod(n,10) == 0)
    s = num2str(M*n*dt);
    waitbar(M*n/Lt,w,['t = ',s,'s']);
  endif
  refreshdata
  drawnow
endfor
s = num2str(M*n*dt);
waitbar(1,w,['Finalizado ','t = ',s,'s']);
toc

clear#livra memororia