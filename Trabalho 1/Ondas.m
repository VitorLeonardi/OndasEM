c = 3e+8;
l = 10;
Rl = [inf,0,100];
Rs = 45;
Uf = 0.9*c;
l = 100;

dz = 1e-2;
dt = dz/(10*c);


z = -l:dz:0;
t = dt:dt:100;
#[zz,tt] = meshgrid(z,t);


R = 1;
G = 1;
L = 1;
C = 1;

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
  y = u(t) - u(t - l/(10*Uf));
endfunction

i = v = zeros(1,l/dz);

#{
i(n,k) -> i(n+1/2,k)
v(n,k) -> v(n,k+1/2)
#}

for n = z
  for k = t
    i(n,k) = c1*(v(n,k) - v(n,k-1)) + c2*i(n-1,k);
    v(n+1,k) = c3*(i(n,k+1) - i(n ,k)) + c4*v(n,k);    
  endfor    
  hold on;
  mesh(i,v,)  
  hold off;
  drawnow();
endfor

