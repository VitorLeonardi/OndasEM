Rl = [inf,0,100]; #resistencia da carga
Rs = 75; #resistencia fonte
Z0 = 50 ; #resistencia da linha
c = 3e+8; #velocidade da luz
uf = 0.9*c; #velocidade de propagacao do sinal
#valores acima na descricao do projeto 

l = 1;  # comprimento da linha, valor p teste
T = 10*l/uf;  #tempo limite, na decricao do projeto 

R = 0;
G = 0;
L = Z0/uf; #Z0 = L* Uf
C = L/Z0**2; #Z0 = sqrt(L/C)
#L e C sao derivados de uf e Z0

dz = 1e-2; #valor p teste
z = -l:dz:0;

dt = dz/uf; #valor p teste, dt<=dz/uf
t = 0:dt:T;

#funcao degrau
function y = u(t)
  if t<=0
    y = 0;
  else
    y = 1;
  endif
endfunction

#funcoes para tensao da fonte
function y = Vs(t,m)
  if m = 1
    y = 2*u(t);
  else
    y = u(t) - u(t - l/(10*uf));# valor p teste
  endif
endfunction


#constantes da equcao de update
c1 = -2*dt/(dt*dz*R + 2*dz*L);
c2 = (2*L * R*dt)/(2*L + dt*R);
c3 = -2*dt/(dt*dz*G + 2*dz*C);
c4 = (2*C- dt*G)/(2*C + dt*G);



Lz = length(z)
Lt = length(t)
i = v = zeros( Lt , Lz );

k1 = 0.5*(Rs*C*dz/(2*dt)-1);
k2 = 0.5*(Rs*C*dz/(2*dt)+1);;

#{
i(n,k) -> i(n+1/2,k)
v(n,k) -> v(n,k+1/2)
#}

#tic toc mede o tempo gasto
tic 
for n = 2:Lt
  i(n,1) = Vs((n-1/2)*dt,1)/Rs - C*dz/(2*dt)(v(n+1,1)- v(n,1)) - v(n,1)/Rs;
  v(n,1) = (k1/k2)*v(n-1,1) - (Rs*i(n-1,1) - (Vs(n*dt,1) + Vs((n-1)*dt,1))/2)/k2;
  #equacao de update
  #codigo vetorizado, muito mais rapido
  
  i(n,2:Lz-1) = c1*(v(n-1,2:Lz-1) - v(n-1,1:Lz-2)) + c2*i(n-1,2:Lz-1); 
  v(n,2:Lz-1) = c3*(i(n,3:Lz) - i(n,2:Lz-1)) + c4*v(n-1,2: Lz-1);    
  
  #condicoes de fronteira k = K
  #circuito aberto
  v(n,Lz) = v(n,Lz-1);
  i(n,Lz) = 0;
endfor
toc

x = v(1,:);
y = i(1,:);
subplot(3,1,1);
plot (z, x,'ydatasource','y');
xlabel("z");
ylabel("v(z)");
subplot(3,1,2);
plot (z, y,'ydatasource','y');
xlabel("z");
ylabel("i(z)");
# plotar apenas alguns valores para guanho de performance

tic
for n = 2:Lt#Lt/M para plotar 1 a cada M tempos,x = v(M*n,:),y = i(M*n,:) 
x = v(n,:);
y = i(n,:);
refreshdata
drawnow
endfor
toc

clear#temporario, livra memororia