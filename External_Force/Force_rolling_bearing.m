function [Fbe,DETA_be] = Force_rolling_bearing(Wegit_all,Lesh1,Lesh2,k_be1,k_be2)
Fbe2 = (-Wegit_all(3,:)*2*Lesh1-Wegit_all(9,:)*Lesh1+Wegit_all(21,:)*Lesh2+Wegit_all(27,:)*2*Lesh2)/(2*Lesh2);
Fbe1 = -(Wegit_all(3,:)+Wegit_all(9,:)+Wegit_all(15,:)+Wegit_all(21,:)+Wegit_all(27,:))-Fbe2;
Z_be1 = -Fbe1/k_be1;
Z_be2 = -Fbe2/k_be2;
DETA_be_1 = [0;0;Z_be1;0;0;0];
DETA_be_2 = [0;0;Z_be2;0;0;0];
Fbe1 = [0;
        0;
        Fbe1 ;
        0;
        0;
        0];
Fbe2 = [0;
        0;
        Fbe2 ;
        0;
        0;
        0];
Fbe = double(vertcat(zeros(12,1),Fbe1,zeros(6,1),Fbe2));
DETA_be = double(vertcat(zeros(12,1),DETA_be_1,zeros(6,1),DETA_be_2));
end

