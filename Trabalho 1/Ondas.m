Rl = [inf,0,100]; #resistencia da carga
Rs = 45; #resistencia fonte
Z0 = 50 ; #resistencia da linha



l = 10;  # comprimento da linha, valor p teste
T = l/(1e+3) ; #tempo limite, valor p teste

R = 0;
G = 0;
L = 1e-3;#valor p teste
C = 1e-3;#valor p teste

#{
L*C < 1e-8  demoram muito( ~4 min), L*C < 1e-10  usam muita memória, matriz zeros linha 47(~4gb)
valores fazem com que dt seja muito pequeno
#}


c = 1/sqrt(L*C);

dz = 1e-2; #valor p teste
z = -l:dz:0;

dt = dz/(2*c); #valor p teste
t = 0:dt:T;

#constantes da equcao de update
c1 = -2*dt/(dt*dz*R + 2*dz*L);
c2 = (2*L * R*dt)/(2*L + dt*R);
c3 = -2*dt/(dt*dz*G + 2*dz*C);
c4 = (2*C- dt*G)/(2*C + dt*G);

 
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
  y = u(t) - u(t - l/(27e+8));# valor p teste
endfunction


Lz = length(z);
Lt = length(t);
i = v = zeros( Lt , Lz );


#condicoes iniciais
v(1,1) = 2;
i(1,1) = v(1,1)/Z0;
#{
v(1,length(z)) = ;
i(1,length(z)) = ;

i(n,k) -> i(n+1/2,k)
v(n,k) -> v(n,k+1/2)
#}


#tic toc mede o tempo gasto
tic 
for n = 2:length(t)
  #{
  i(2,1)= ; 
  v(2,1)= ;
  atualizar condicoes iniciais para Vs2()
  
  equacao de update
  codigo vetorizado, muito mais rapido
  #} 
  i(n,2:Lz-1) = c1*(v(n-1,2:Lz-1) - v(n-1,1:Lz-2)) + c2*i(n-1,2:Lz-1); 
  v(n,2:Lz-1) = c3*(i(n,3:Lz) - i(n,2:Lz-1)) + c4*v(n-1,2: Lz-1);    
  
endfor
toc


# apenas alguns valores sao plotados, grande ganho em performance e baixa perda visual

#valores para teste
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