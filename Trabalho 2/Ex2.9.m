#2.9

c = 3e+8;

L = 10;#comprimento
T = 1.2*L/c;#tempo total

S = [1 0.25];

dt = T/500;
Lt = length(0:dt:T); 

itr = 0.6*L; #interface

dx = c*dt./S;
x1 = 0:dx(1):itr;
x2 = itr+dx(2):dx(2):L;

x = [x1 x2];
Lx = [length(x1) length(x)];

function y = start(k,T) #fonte pulso gaussiano
  y = exp(-(6e8*(k-T/3))**2);
endfunction

u = zeros(Lt,Lx(2));
for n = 2:Lt;
  u(n,1) = start(n*dt,T); 
  u(n+1,2:Lx(1)) = S(1)**2 *( u(n,3:Lx(1)+1) - 2*u(n,2:Lx(1)) + u(n,1:Lx(1)-1))+ 2*u(n,2:Lx(1)) - u(n-1,2:Lx(1)); #2.16
  u(n+1,Lx(1)+1:Lx(2)-1) = S(2)**2 *( u(n,Lx(1)+2:Lx(2)) - 2*u(n,Lx(1)+1:Lx(2)-1) + u(n,Lx(1):Lx(2)-2))+ 2*u(n,Lx(1)+1:Lx(2)-1) - u(n-1,Lx(1)+1:Lx(2)-1); #2.16  
endfor

hold on
#plot grafico
U = u(1,:);
h = plot (x, U,'ydatasource','U','color','b','linewidth',1.5);
plot([itr itr],[-1.1 1.1],'--r');
annotation('textbox', [0.3, 0.85, 0, 0], 'String', ["S = " num2str(S(1))],'color','k','edgecolor','none');
annotation('textbox', [0.8, 0.85, 0, 0], 'String', ["S = " num2str(S(2))],'color','k','edgecolor','none');
axis([0 L -1.1 1.1]);
for n = 1:Lt
  U = u(n,:);
  refreshdata
  drawnow
endfor
saveas(h,"Ex2.9.png","png");
clear