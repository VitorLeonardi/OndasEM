Rl = [inf,0,100]; #resistencia da carga
Rs = 75; #resistencia fonte
Z0 = 50 ; #resistencia da linha
c = 3e+8; #velocidade da luz
uf = 0.9*c; #velocidade de propagacao do sinal
#valores acima na descricao do projeto 

l = 1;  # comprimento da linha, valor p teste
T = 4*l/uf;  #tempo limite, na decricao do projeto 

L = Z0/uf; #Z0 = L* Uf
C = L/Z0**2; #Z0 = sqrt(L/C)
#L e C sao derivados de uf e Z0

dz = 1e-3; #valor p teste
z = -l:dz:0;

dt = dz/(2*uf); #valor p teste, dt<dz/uf
t = 0:dt:T;

#funcao degrau
function y = u(t)
  if (t<=0)
    y = 0;
  else
    y = 1;
  endif
endfunction

#funcoes para tensao da fonte
function y = Vs(t,m,uf)
  if m==1;
    y = 2*u(t);
  else
    y = u(t) - u(t - 1/(10*uf));# valor p teste
  endif
endfunction


Lz = length(z)
Lt = length(t)
i = v = zeros( Lt , Lz );
k1 = 0.5*(Rs*C*dz/(2*dt)-1);
k2 = 0.5*(Rs*C*dz/(2*dt)+1);

#{
i(n,k) -> i(n,k+1/2)
v(n,k) -> v(n+1/2   ,k)
#}

#tic toc mede o tempo gasto

tic 
for n = 2:Lt
  v(n,1) = (k1/k2)*v(n-1,1) - (Rs*i(n,1) - (Vs((n+1/2)*dt,2,uf) + Vs((n-1/2)*dt,2,uf))/2)/k2;
  #equacao de update
  #codigo vetorizado, muito mais rapido, linha sem perdas ,Gedney p43
  v(n,2:Lz) = v(n-1,2:Lz) - dt*(i(n,2:Lz) - i(n,1:Lz-1))/(C*dz);
  i(n+1,1:Lz-1) = i(n,1:Lz-1) - dt*(v(n,2:Lz)-v(n,1:Lz-1))/(L*dz);
 #i(n+1,Lz) = i(n+1,Lz-1) e v(n,Lz) = 0 pra Rl = 0
  i(n+1,Lz) = v(n,Lz)/Rl(3);
endfor
toc


V = v(1,:);
I = i(1,:);
subplot(2,1,1);
plot (z, V,'ydatasource','V');
xlabel("z");
ylabel("v(z)");
axis([-l 0 min(min(v)) max(max(v))]);
subplot(2,1,2);
plot (z, I,'ydatasource','I');
xlabel("z");
ylabel("i(z)");
axis([-l 0 min(min(i)) max(max(i))]);
w = waitbar(0,'time');
# plotar apenas alguns valores para guanho de performance

tic
for n = 1:Lt#Lt/M para plotar 1 a cada M tempos,x = v(M*n,:),y = i(M*n,:) 
  I = i(n,:);
  V = v(n,:);
  waitbar(n/Lt,w,'time');
  refreshdata
  drawnow
endfor
toc

clear#temporario, livra memororia
