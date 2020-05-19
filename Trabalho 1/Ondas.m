Rl = [inf,0,100]; #resistencia da carga
Rs = 45; #resistencia fonte

Z0 = 50 ; #resistencia da linha
R = 0;
G = 0;
L = 252e-2;
C = 101e-6;

c = 1/sqrt(L*C);

l = 10;  # comprimento da linha
T = l/(0.9*3e+2) ; #tempo limite

dz = 1e-1;
dt = dz/(2*c);
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
  y = u(t) - u(t - l/(27e+8));
endfunction

i = v = zeros(length(t) , length(z) );


#condicoes iniciais
v(1,1) = 2;
i(1,1) = v(1,1)/Z0;

#v(1,length(z)) = ;
#i(1,length(z)) = ;

subplot(2,1,1);
plot(z,i(1,:));
xlabel("z");
ylabel("i(z)");
subplot(2,1,2);
plot(z,v(1,:));
xlabel("z");
ylabel("v(z)");
drawnow();

#{
i(n,k) -> i(n+1/2,k)
v(n,k) -> v(n,k+1/2)
#}



for n = 2:length(t);
  #i(2,1)= ;
  #v(2,1)= ;
  
  for k = 2:length(z)-1;
    i(n,k) = c1*(v(n-1,k) - v(n-1,k-1)) + c2*i(n-1,k); 
  endfor
  
  for k = 2:length(z)-1;
    v(n,k) = c3*(i(n,k+1) - i(n,k)) + c4*v(n-1,k);    
  endfor
  
  subplot(2,1,1);
  plot(z,i(n,:));
  xlabel("z");
  ylabel("v(z)");
  
  subplot(2,1,2);
  plot(z,v(n,:));
  xlabel("z");
  ylabel("i(z)");
  
  drawnow();
  
endfor

