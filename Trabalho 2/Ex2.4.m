#Ex 2.4 
S = 1/sqrt(2);
nt = 2*pi*S/acos(1-2*S**2); #2.30

d = 0.001;

N1 = 1:d:nt;
N2 = nt+d:d:10;

Vp1 = 2./N1; #2.37a
Vp2 = 2*pi./(N2.*acos(1+(1/S)**2 *(cos((2*pi*S)./N2)-1))); #2.32c

N = [N1 N2];
Vp = [Vp1 Vp2];

z = 1 + (cos(2*pi*S./N1)-1)/S**2; #2.29b
r = -log(-z - sqrt(z.**2 - 1)); #2.37b

y = plotyy(N1,r,N,Vp);
xlabel("Grid Sampling Density");
ylabel(y(1),"Attenuation constant( nepers / grid cell )");
ylabel(y(2),"Numerical phase velocity ( normalized to c ) ");

hold on
h = plot([nt nt],[-1 2],'--k');
saveas(h,"Ex2.4.png","png");
