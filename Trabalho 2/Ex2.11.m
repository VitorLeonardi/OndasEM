#2.11
c = 3e+8;



dt  = 0.1/c;
Lx = 200;
S = ones(1,Lx);
S(90) = 1.075;

dx = dt*c./S;
x = cumsum(dx);

Lt = [190 200];

function y = start(t) #fonte pulso gaussiano
  y = exp(-(1e8*(t-3e-8))**2)
endfunction
hold on
for w = 1
  u = zeros(Lt(w),Lx);
  for n = 2:Lt(w);
    #Equacao de update
    u(n,1) = start(n*dt); 
    u(n+1,2:Lx-1) = S(2:Lx-1).**2 .*( u(n,3:Lx) - 2*u(n,2:Lx-1) + u(n,1:Lx-2))+ 2*u(n,2:Lx-1) - u(n-1,2:Lx-1); #2.16  
  endfor

  #plot grafico
  switch w
    case 1
      U1 = u(1,:);
      h = plot (x, U1,'ydatasource','U1','color','r','linewidth',1.5);
      annotation('textbox', [0.3, 0.85, 0, 0], 'String', ["n = " num2str(Lt(w))],'color','r','edgecolor','none');
      for n = 1:Lt(w)
        U1 = u(n,:);
        refreshdata
        drawnow
      endfor
    case 2
      U2 = u(1,:);
      plot (x, U2,'ydatasource','U2','color','b','linewidth',1.5);
      annotation('textbox',[0.3, 0.8, 0, 0], 'String', ["n = " num2str(Lt(w))],'color','b','edgecolor','none')
      for n = 1:Lt(w)
        U2 = u(n,:);
        refreshdata
        drawnow
      endfor
  endswitch
  
endfor
