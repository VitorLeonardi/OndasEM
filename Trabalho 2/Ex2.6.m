c= 3e+8;

L = 10;
T = L/c;
dx = 1e-2;
x = 0:dx:L;

S = 1;

dt = S*dx/c;
t = 0:dt:T;

Lx = length(x);
Lt = length(t) ; 




u = zeros(Lt,Lx);
function y = start(k,L,c)
  if k < L /(10*c);
    y = 1;
  else y = 0;
  endif
endfunction



tic
for n = 3:Lt;
  u(n-1,1) = start(n*dt,L,c);
  u(n,2:Lx-1) =  u(n-1,3:Lx) - u(n-2,2:Lx-1) + u(n-1,1:Lx-2);  
endfor
toc


U = u(1,:);
plot (x, U,'ydatasource','U');
axis([0 L 1.1*min(min(u)) 1.1*max(max(u))]);

for n = 1:Lt
  U = u(n,:);
  refreshdata
  drawnow
endfor


