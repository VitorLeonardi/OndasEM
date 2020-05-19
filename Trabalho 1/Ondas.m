Rl = [inf,0,100]; #resistencia da carga
Rs = 45; #resistencia fonte

Z0 = 50 ; #resistencia da linha
R = 0;
G = 0;
L = 252e-3;#valor p teste
C = 101e-6;#valor p teste
#valores  de L e C muito pequenos usam muita memoria ( ~ 1e-5 ou menores), matriz linha 43
c = 1/sqrt(L*C);

l = 20;  # comprimento da linha, valor p teste
T = l/(0.9*3e+2) ; #tempo limite, valor p teste

dz = 1e-2; #valor p teste
dt = dz/(2*c); #valor p teste

z = -l:dz:0;
t = 0:dt:T;

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

function y = Vs1(t)
  y = 2*u(t);
endfunction

function y = Vs2(t,l)
  y = u(t) - u(t - l/(27e+8));# valor p teste
endfunction

i = v = zeros( length(t) , length(z) );
Lz = length(z);


#condicoes iniciais
v(1,1) = 2;
i(1,1) = v(1,1)/Z0;

#v(1,length(z)) = ;
#i(1,length(z)) = ;

n = 1;

subplot(2,1,1);
plot(z,i(n,:));
xlabel("z");
ylabel("i(z)");

subplot(2,1,2);
plot(z,v(n,:));
xlabel("z");
ylabel("v(z)");
drawnow;

#{
i(n,k) -> i(n+1/2,k)
v(n,k) -> v(n,k+1/2)
#}


for n = 2:length(t)
  #i(2,1)= ;
  #v(2,1)= ;
  # codigo vetorizado, muito mais rápido
  i(n,2:Lz-1) = c1*(v(n-1,2:Lz-1) - v(n-1,1:Lz-2)) + c2*i(n-1,2:Lz-1); 
  v(n,2:Lz-1) = c3*(i(n,3:Lz) - i(n,2:Lz-1)) + c4*v(n-1,2: Lz-1);    
  
endfor

# apenas alguns valores são plotados, muito mais rápido 
for n = 1:(length(t)/50)#um em cada 50, valor p teste
  subplot(2,1,1);
  plot(z,i(50*n,:));
  xlabel("z");
  ylabel("i(z)");

  subplot(2,1,2);
  plot(z,v(50*n,:));
  xlabel("z");
  ylabel("v(z)");
  drawnow;
  
endfor
