#Ex 2.5 

S = 0.5;
c = 3e+8;
nt = 2*pi*S/acos(1-2*S**2); #2.30

d = 0.001;
N = nt+d:d:80;

Vp = 2*pi./(N2.*acos(1+(1/S)**2 *(cos((2*pi*S)./N2)-1))); #2.32c , normalizado

Er = (1 - Vp)*100 ;

h = semilogy(N,Er);
title("S = 0.5");
xlabel("Grid Sampling Density");
ylabel("Phase velocity error ( % )");
saveas(h,"Ex2.5.png","png");
