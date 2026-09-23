function FedWr = DiskElementForces_of_Weight(md,beta,gama)
%DiskElementForce_of_Weight  
%此函数返回质量为md、(md,beta,gama)
%重力加速度g=9.81
%转盘重力产生的支撑力FedWr。
a = [-cos(beta)*sin(gama) ; 
     sin(beta);
     cos(beta)*cos(gama) ; 
     0 ;
     0 ;
     0 ];
FedWr = -9.81*md*a;%已经写完
end