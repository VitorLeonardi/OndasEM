#Ex 2.6 

S = 1/sqrt(2);
c = 3e+8;
nt = 2*pi*S/acos(1-2*S**2); #2.30

d = 0.001;
N = nt+d:d:80;

Vp = 2*pi./(N.*acos(1+4*(cos(pi./N)-1))); #2.32c , normalizado

Er = (1 - Vp)*100 ;

h = semilogy(N,Er);
title("S = 1/sqrt(2)");
xlabel("Grid Sampling Density");
ylabel("Phase velocity error ( % )");
saveas(h,"Ex2.6.png","png");
