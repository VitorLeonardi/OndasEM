#2.9
c = 3e+8;

L = 10;#comprimento
T = 1.35*L/c;#tempo total

S = [1 0.25];

dt = T/300;
Lt = length(0:dt:T); 

dx = c*dt./S;
x1 = 0:dx(1):0.7*L;
x2 = 0.7*L+dx(2):dx(2):L;

x = [x1 x2];
Lx = [length(x1) length(x)];

function y = start(k,T,c) #fonte pulso gaussiano
  y = exp(-(c*(k-T/3))**2);
endfunction

u = zeros(Lt,Lx(2));
for n = 2:Lt;
  u(n,1) = start(n*dt,T,c); 
  u(n+1,2:Lx(1)) = S(1)**2 *( u(n,3:Lx(1)+1) - 2*u(n,2:Lx(1)) + u(n,1:Lx(1)-1))+ 2*u(n,2:Lx(1)) - u(n-1,2:Lx(1)); #2.16
  u(n+1,Lx(1)+1:Lx(2)-1) = S(2)**2 *( u(n,Lx(1)+2:Lx(2)) - 2*u(n,Lx(1)+1:Lx(2)-1) + u(n,Lx(1):Lx(2)-2))+ 2*u(n,Lx(1)+1:Lx(2)-1) - u(n-1,Lx(1)+1:Lx(2)-1); #2.16  
endfor

hold on
#plot grafico
U = u(1,:);
plot (x, U,'ydatasource','U','color','r');
plot([0.7*L 0.7*L],[-1.1 1.1],'--b');
axis([0 L -1.1 1.1]);
for n = 1:Lt
  U = u(n,:);
  refreshdata
  drawnow
endfor

clear
