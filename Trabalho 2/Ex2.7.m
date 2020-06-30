#ex 2.7
c = 3e+8;
L = 10;#comprimento
T = 0.9*L/c;#tempo total

dx = L/150;
x = 0:dx:L;
Lx =   length(x);

S = [0.5 1];

dt = S*dx/c; #2.28a
Lt = [length(0:dt(1):T) length(0:dt(2):T)]; 

function y = start(k,L,c) #fonte

  if (k < L/(c*5))
    y = 1;
  else 
    y = 0;
  
endif
endfunction

hold on
for w = [1 2]
  u = zeros(Lt(w),Lx);
  for n = 2:Lt(w);
    u(n,1) = start(n*dt(w),L,c) ;
    u(n+1,2:Lx-1) = S(w)**2 *( u(n,3:Lx) - 2*u(n,2:Lx-1) + u(n,1:Lx-2))+ 2*u(n,2:Lx-1) - u(n-1,2:Lx-1); #2.16  
  endfor

  #plot grafico
  if w == 1
    U1 = u(1,:);
    plot (x, U1,'ydatasource','U1','color','r');
    axis([0 L -0.4 1.4]);
    annotation('textbox', [0.3, 0.85, 0.07, 0.03], 'String', ["S = " num2str(S(w))],'color','r');
    for n = 1:Lt(w)
      U1 = u(n,:);
      refreshdata
      drawnow
    endfor
  else
    U2 = u(1,:);
    plot (x, U2,'ydatasource','U2','color','b');
    axis([0 L -0.4 1.4]);
    annotation('textbox', [0.4, 0.85, 0.07, 0.03], 'String', ["S = " num2str(S(w))],'color','b')
    for n = 1:Lt(w)
      U2 = u(n,:);
      refreshdata
      drawnow
    endfor
  endif
  
endfor

clear