#ex 2.7

c= 3e+8;

L = 10;#comprimento
T = L/c;#tempo total

dx = 1e-2;
x = 0:dx:L;

S = 1;
# S = 1 "magical step"
# S = c*dt/dx
#S = 1, 0.99, 0.5
dt = S*dx/c; #2.28a
t = 0:dt:T;

Lx = length(x);
Lt = length(t); 

u = zeros(Lt,Lx);

function y = start(k,L,c) #fonte
  if k < L /(10*c);
    y = 1;
  else y = 0;
  endif
endfunction



tic
for n = 3:Lt;
  u(n-1,1) = start(n*dt,L,c);
  u(n+1,2:Lx-1) = S**2 *( u(n,3:Lx) - 2*u(n,2:Lx-1) + u(n,1:Lx-2))+ 2*u(n,2:Lx-1) - u(n-1,2:Lx-1); #2.16    
endfor
toc

#plot grafico
U = u(1,:);
plot (x, U,'ydatasource','U');
axis([0 L 1.1*min(min(u)) 1.1*max(max(u))]);

for n = 1:Lt
  U = u(n,:);
  refreshdata
  drawnow
endfor
clear

