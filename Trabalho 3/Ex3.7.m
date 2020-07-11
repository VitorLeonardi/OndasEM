#3.7
# eq 3.41 a,b,c 


e0 = 8.8541878128e-12;   #permissividade eletrica do vacuo
u0 = 1.25663706212e-6;   #permeabilidade magnetica do vacuo
c = 1/sqrt(e0*u0); #velocidade da luz


cel = 0.01; #celdutividade eletrica
pmg = 0.01; #perda magnetica

L = 1; #tamanho mesh;  lim Ez = 0
T = 100; #tempo limite

dx = 1e-2; #dx = dy
x = -L:dx:L;
dt = dx/(sqrt(2)*c);

Lx = length(x); #numero de divisoes espaciais em cada coordenada(x,y)
length(0:dt:L) #numero de passos temporais
Lt = 5000;
#constantes da equacoa de update
Ca = (1 - cel*dt/(2*e0))/(1 + cel*dt/(2*e0)); #3.31a
Cb = (dt/(e0*dx))/(1 + cel*dt/(2*e0)); #3.31b
Da = (1 - pmg*dt/(2*u0))/(1 + pmg*dt/(2*u0));#3.32a
Db = (dt/(u0*dx))/(1 + pmg*dt/(2*u0)); #3.32b

#matrizes para calculos, armazenam apenas os estados atual e anterior
Ez = Hx = Hy = zeros(Lx,Lx,2);

N = 10; #Salva apenas 1 em cada N estados de cada campo para plot, economiza memoria  
PltEz = PltHx = PltHy = zeros(Lx,Lx,int32(Lt/N));

#M
#J
z = find(x == 0); #centro da mesh

function y = inicond(t)
  y = cos(1e8*t);
endfunction
tic
for n = 2:Lt
  Ez(z,z,1) = inicond(n*dt);
  #equacoes de update
  
  Ez(1:Lx-1,1:Lx-1,2) = Ca*Ez(1:Lx-1,1:Lx-1,1) + Cb*(Hy(2:Lx,1:Lx-1,1) - Hy( 1:Lx-1,1:Lx-1,1) + Hx(1:Lx-1,1:Lx-1,1) - Hx(1:Lx-1,2:Lx,1)); # eq 3.41a
  Ez(z,z,2) = inicond(n*dt);#conserta Ez(0,0)
  
  Hx(1:Lx,2:Lx,2) = Da*Hx(1:Lx,2:Lx,1) + Db*( Ez(1:Lx,1:Lx-1,2) - Ez(1:Lx,2:Lx,2) );# eq 3.41b
  Hy(2:Lx,1:Lx,2) = Da*Hy(2:Lx,1:Lx,1) + Db*( Ez(2:Lx,1:Lx,2) - Ez(1:Lx-1,1:Lx,2) );# eq 3.41c
  
  Ez(1:Lx,1:Lx,1) =  Ez(1:Lx,1:Lx,2);
  Hx(1:Lx,1:Lx,1) =  Hx(1:Lx,1:Lx,2);
  Hy(1:Lx,1:Lx,1) =  Hy(1:Lx,1:Lx,2);
  
  if( mod(n,N) == 0 )
    PltEz(1:Lx,1:Lx,n/N) =  Ez(1:Lx,1:Lx,2);
    PltHx(1:Lx,1:Lx,n/N) =  Hx(1:Lx,1:Lx,2);
    PltHy(1:Lx,1:Lx,n/N) =  Hy(1:Lx,1:Lx,2);
  endif

endfor
toc
#plot

X = meshgrid(x,x);
Z = PltEz(1:Lx,1:Lx,1);
mesh(X, X', Z ,'zdatasource','Z');
axis([-1 1 -1 1 -1 1]);
for n = 1:int32(Lt/N)
  Z = PltEz(1:Lx,1:Lx,n);
  refreshdata
  drawnow
endfor
