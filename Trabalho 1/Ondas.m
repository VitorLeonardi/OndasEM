Rl = [inf,0,100]; #resistencia da carga
Rs = 75; #resistencia fonte

Z0 = 50 ; #resistencia da linha
R = 0;
G = 0;
L = 252e-9;
C = 101e-12;

c = 1/sqrt(L*C);

l = 100;  # comprimento da linha
T = 10*l/(0.9*3e+8) ; #tempo limite

dz = 1e-2;
dt = dz/(10*c);
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

i = v = zeros(2 , length(z) );


#condicoes iniciais
v(1,1) = 2;
i(1,1) = v(1,1)/Z0;

#v(1,length(z)) = ;
#i(1,length(z)) = ;

plot3(i(1,:),v(1,:),z);
drawnow();

#{
i(n,k) -> i(n+1/2,k)
v(n,k) -> v(n,k+1/2)
#}



for n = 2:length(t);
  #i(2,1)= ;
  #v(2,1)= ;
  
  for k = 2:length(z)-1;
    i(2,k) = c1*(v(1,k) - v(1,k-1)) + c2*i(1,k); 
  endfor
  
  for k = 2:length(z)-1;
    v(2,k) = c3*(i(2,k+1) - i(2,k)) + c4*v(1,k);    
  endfor
  i(1,:) = i(2,:);
  v(1,:) = v(2,:);
  plot3(i(1,:),v(1,:),z);
  drawnow();
endfor

