%Ex 2.4 
S = 1/sqrt(2);
c = 3e+8;
nt = 2*pi*S/acos(1-2*S**2); #2.30

d = 0.001;

N1 = 1:d:nt;
N2 = nt+d:d:10;

Vp1 = 2./N1; #2.37a
Vp2 = 2*pi./(N2.*acos(1+4*(cos(pi./N2)-1))); #2.32c

N = [N1 N2];
Vp = [Vp1 Vp2];

plot(N,Vp,'b','linewidth',1);
str = "Velocidade de fase";
xlabel("Grid Sampling Density");
ylabel("Numerical phase velocity ( normalized to c ) ");
annotation('textbox',[.7 .4 .3 .3],'String',str);

clear
