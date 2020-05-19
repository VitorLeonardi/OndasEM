Rl = [inf,0,100]; #resistencia da carga
Rs = 75; #resistencia fonte
Z0 = 50 ; #resistencia da linha
c = 3e+8; #velocidade da luz
uf = 0.9*c #velocidade de propagacao do sinal
#valores acima na descricao do projeto 

l = 10;  # comprimento da linha, valor p teste
T = 10*l/uf  #tempo limite, na decricao do projeto 

R = 0;
G = 0;
L = Z0/uf #Z0 = L* Uf
C = L/Z0**2 #Z0 = sqrt(L/C)
#L e C sao derivados de uf e Z0

dz = 1e-2; #valor p teste
z = -l:dz:0;

dt = dz/(2*uf) #valor p teste, dt<dz/uf
t = 0:dt:T;

#funcao degrau
function y = u(t)
  if t<0
    y = 0;
  else
    y = 1;
  endif
endfunction

#funcoes para tensao da fonte
function y = Vs1(t)
  y = 2*u(t);
endfunction

function y = Vs2(t,l)
  y = u(t) - u(t - l/(10*uf));# valor p teste
endfunction

#constantes da equcao de update
c1 = -2*dt/(dt*dz*R + 2*dz*L)
c2 = (2*L * R*dt)/(2*L + dt*R)
c3 = -2*dt/(dt*dz*G + 2*dz*C)
c4 = (2*C- dt*G)/(2*C + dt*G)

Lz = length(z)
Lt = length(t)
i = v = zeros( Lt , Lz );

#constantes das condicoes de fronteira
k1 = (Rs*C*dx/dt - 1 )/(Rs*C*dx/dt + 1);
k2 = -2*Rs/(Rs*C*dx/dt+1);
k3 = (Rl*C*dx/dt - 1 )/(Rl*C*dx/dt + 1);
k4 = -2*Rl/(Rl*C*dx/dt+1);


#condicoes iniciais, acho q ainda esta errado
v(1,1) = 2;
i(1,1) = v(1,1)/Z0;

#{
i(n,k) -> i(n+1/2,k)
v(n,k) -> v(n,k+1/2)
#}


#equacoes 5 e 6a formam um sistema linear para i(n,1) e v(n,1)
#A*r = b, r(i,v), eu n tenho ideia se isso funciona
A = zeros(2);
b = zeros(2,1);
A(1,1)  = 1;
A(1,2) = C*dx/(2*dt) - 1/Rs;
A(2,1) = k2;
A(2,2) = -1;

#tic toc mede o tempo gasto
tic 
for n = 2:Lt
  #condicoes de fronteira k = 1
  b(1) = Vs1(n*dt)/Rs - v(n-1,1)/dt;
  b(2) = ()/2 - k1*v(n-1,1);
  r = A\b;
  i(n,1) = r(1);
  v(n,1) = r(2);
  #{
  atualizar condicoes iniciais para Vs2()
  
  equacao de update
  codigo vetorizado, muito mais rapido
  #} 
  i(n,2:Lz-1) = c1*(v(n-1,2:Lz-1) - v(n-1,1:Lz-2)) + c2*i(n-1,2:Lz-1); 
  v(n,2:Lz-1) = c3*(i(n,3:Lz) - i(n,2:Lz-1)) + c4*v(n-1,2: Lz-1);    
  
  #condicoes de fronteira k = K
  v(n,Lz) = k3*v(n-1,Lz) + k4*i(n,Lz-1);
  i(n,Lz) = ;#ainda n sei fazzer isso
endfor
toc

# apenas alguns valores sao plotados, grande ganho em performance e baixa perda visual

#valores para teste, plota 1 a cada jump_ valores
jump_t = 100;
jump_z = 10;

new_i = i(1:jump_t:Lt,1:jump_z:Lz);
new_v = v(1:jump_t:Lt,1:jump_z:Lz);
new_z = z(1:jump_z:Lz);

tic
for n = 1:length(1:jump_t:Lt)
  
  subplot(2,1,1);
  plot(new_z,new_i(n,:));
  xlabel("z");
  ylabel("i(z)");

  subplot(2,1,2);
  plot(new_z,new_v(n,:));
  xlabel("z");
  ylabel("v(z)");
  
  drawnow;
endfor
toc
clear#temporario, livra memororia
