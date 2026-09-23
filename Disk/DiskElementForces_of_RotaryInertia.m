function Fedlamuda = DiskElementForces_of_RotaryInertia(imdy,FAI)
%DiskElementForces_of_RotaryInertia，(imdy,FAI)
%此函数返回绕Oy主轴的主惯性矩为imdy的转盘的节点惯性力矩阵y=Fedlamuda（t），
%节点惯性力矩阵-Fedlamuda(t)的大小为6 x 1。
a = [0 ; %关于转盘速度的陀螺效应
     0 ;
     0 ; 
     0 ;
     imdy ;
     0 ];
Fedlamuda = -a*diff(FAI,2);%已经写完
end