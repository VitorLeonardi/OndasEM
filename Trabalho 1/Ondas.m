Rl = inputdlg('Entre resistência da carga: ','Sample',[1 5]);
m = inputdlg('Entre tensão da fonte','Sample',[1 5]);#modo Vs m=1,2
p = inputdlg('dz = Z/p ,p = ','Sample',[1 5]);
Rl = str2num(Rl{1});
m = str2num(m{1});
p = str2num(p{1});

#funcoes para tensao da fonte
function y = Vs(t,m,uf,Z)
  if (m == 1);
    y = 2;
  elseif (t < Z/(10*uf))
    y = 1;# valor p teste
  else
    y = 0;
  endif
endfunction

tic
Rs = 75; #resistencia fonte
Z0 = 50 ; #resistencia da linha
c = 3e+8; #velocidade da luz
uf = 0.9*c; #velocidade de propagacao do sinal
#valores acima na descricao do projeto 

Z = 10;  # comprimento da linha, valor p teste
T = 10*Z/uf;  #tempo limite, na decricao do projeto 

L = Z0/uf; #Z0 = L* Uf
C = L/Z0**2; #Z0 = sqrt(L/C)
#L e C sao derivados de uf e Z0

dz = Z/p; #valor p teste
z = -Z:dz:0;
2
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


for n = 2:Lt-1
  v(n,1) = (k1/k2)*v(n-1,1) - (Rs*i(n,1) - (Vs((n+1/2)*dt,m,uf,Z) + Vs((n-1/2)*dt,m,uf,Z))/2)/k2;
  #equacao de update
  #codigo vetorizado, muito mais rapido, linha sem perdas ,Gedney p43
  v(n,2:Lz-1) = v(n-1,2:Lz-1) - dt*(i(n,2:Lz-1) - i(n,1:Lz-2))/(C*dz);
  if (Rl == 0)
    v(n,Lz) = 0;
    i(n+1,Lz) = i(n+1,Lz-1);
  elseif (Rl == inf)
    v(n,Lz) = v(n,Lz-1);
    i(n+1,Lz) = 0;
  else
    v(n,Lz) = (k1/k2)*v(n-1,Lz) + Rl*i(n,Lz-1)/k2;
    i(n+1,Lz) = v(n,Lz)/Rl;
  endif  
  
  i(n+1,1:Lz-1) = i(n,1:Lz-1) - dt*(v(n,2:Lz)-v(n,1:Lz-1))/(L*dz);

endfor


figure('Name',['Rl = ',num2str(Rl),', m = ', num2str(m)],'NumberTitle','off');
V = v(1,:);
I = i(1,:);
subplot(2,1,1);
plot (z, V,'ydatasource','V');
title('tensão');
xlabel("z (m)");
ylabel("v (V)");
axis([-Z 0 min(min(v)) max(max(v))]);
subplot(2,1,2);
plot (z, I,'ydatasource','I');
title('corrente');
xlabel("z (m)");
ylabel("i (A)");
axis([-Z 0 min(min(i)) max(max(i))]);
w = waitbar(0,'t = 0s');


M = 20;#valor p teste
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
