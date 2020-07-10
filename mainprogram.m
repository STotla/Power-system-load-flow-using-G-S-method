%Created by Sanidhya Totla ,Btech, 
%Institute of Technology ,Nirma University


busdata=busdata6();   % calling function for retrieving bus data.

ybus= YBUS();         % calling Ybus matrix from the function YBUS

Bus=busdata(:,1);     % Bus sequence information

Type=busdata(:,2);                      % Type of Bus 1-for Slack Bus, 2-for PV,3- for PQ

V=busdata(:,3);                         % voltage of buses

theta=busdata(:,4);                     % angle data

gen_MW=busdata(:,5);                    % active power injected to buses

gen_MVAR=busdata(:,6);                  % reactive power injected to buses

load_MW=busdata(:,7);                   % active power ejected from buses

load_MVAR=busdata(:,8);                 % reactive power ejected from buses

Qmin=busdata(:,9);                      %  minimum limit of reactive power

Qmax=busdata(:,10);                     % Maximum limit of reactive power

buses= max(Bus);                        % To get the no. of buses

P=gen_MW-load_MW;                       % Active power at buses

Q=gen_MVAR-load_MVAR;                   %  Reactive power at buses

tolerance= 1;                           % Initialising the value of tolerance

iteration=1;                            % Initialising the value of iteration=1

V_prev=V;
while tolerance > 0.00001               % operating loop till tolreance beacame less than 0.00001
    for i=2:buses
        sumationV=0;
        for k=1:buses
            if i ~= k                            % when i is not equal to k
                sumationV= sumationV+ ybus(i,k)*V(k);      % Y(ik)*v(k)
            end
        end
        if Type(i)==2                             % condition for PV buses
            Q(i)=-imag(conj(V(i))*(sumationV+ ybus(i,i)*V(i)));    % Calculating Q(i) for PV buses
            if Q(i)<Qmin(i) || Q(i)>Qmax(i)       % checking if PV buses violsting the rules or not
                if Q(i)<Qmin(i)
                    Q(i)=Qmin(i);
                end
                if Q(i)>Qmax(i)
                    Q(i)=Qmax(i);
                end
                Type(i)=3;          % if PV bus voilated than they converetd to PQ bus
            end
        end
        V(i)= (1/ybus(i,i))*(((P(i)-1i*Q(i))/conj(V(i)))-sumationV);    % Calcualting the  complex voltage 
        if Type(i)==2                                                   % For PV buses voltage magnitude remain same only angle get affected
            r=abs(V_prev(i));
            o=angle(V(i));
            V(i)= r*cos(o) + 1i*r*sin(o);                                % converting polar to rectangular form
        end                                     
       
    end
        iteration=iteration+1;                       % Incrementing iteration number
        tolerance = max(abs(abs(V) - abs(V_prev)));  %calculating error by subtracting the magtitude of previous iterated voltage by currrent iterated value
        V_prev=V;                                    %assigning V to V_prev
            
end
Vmag = abs(V);      
Angle = 180/pi*angle(V);                          % converting radian to degree format
disp(['no. of iteration=' ,num2str(iteration)]);  % Total iterations.
disp(['Error in the method=' ,num2str(tolerance)]); 
disp(['Bus No.     Voltage     Angle']);            
disp(['---o---------------------------o----'])
   for u=1:buses
       disp([num2str(u),'         ',num2str(Vmag(u)),'         ',num2str(Angle(u))]);  % Displaying the result
       disp(['---o------------------------o-------']);
   end
   
                                   

    