%Created by Sanidhya Totla ,Btech, 
%Institute of Technology ,Nirma University
function ybus=YBUS()                           % creating a function for calculating YBUS matrix of a system
linedata=linedata6();                          % Calling  a function where line data is stored
frb=linedata(:,1);                             % bus number from-
tob=linedata(:,2);                             % bus nimber to-
r= linedata(:,3);                               % Resistance of lines
x= linedata(:,4);                               % Reactance of lines
b= linedata(:,5);                               % Admitance of line(C/2)
buses=max(max(frb),max(tob));                   % Calculating number of Buses
branches= length(frb);                         % Calculating number of Buses
z= r+ j*x;                                     % calculating the impedance of branches
b=j*b;
y= 1./z;                                       % calculating the admittance of branches
ybus= zeros(buses);

% creating dioganal elements 
for r=1:buses
    for n=1:branches
        if frb(n)==r | tob(n)==r
            ybus(r,r)=ybus(r,r)+y(n)+b(n);
        end
    end
end
% creating off digonal elements of matrix
for l=1:branches
    ybus(frb(l),tob(l)) = -y(l);
    ybus(tob(l),frb(l)) = ybus(frb(l),tob(l));
end
ybus;  
zbus=inv(ybus);
        
