function Ced = DiskElementDamping(md,imdmo,imdy,FAI,Wx,Wy,Wz)
%DiskElementMass   
%此函数返回质量为md、(md,imdmo,imdy,FAI,Wx,Wy,Wz)
%平均转动惯量为imdmo、
%绕Oy主轴的主惯性矩为imdy的转盘的节点阻尼矩阵Ced(t)，
%节点阻尼矩阵Ced(t)的大小为6 x 6。
a = [0 0 0 0 0 0; %关于转盘速度的陀螺效应
     0 0 0 0 0 0;
     0 0 0 0 0 0; 
     0 0 0 0 0 -imdy;
     0 0 0 0 0 0;
     0 0 0 imdy 0 0];
b = [0 0 0 0 0 0; %关于参考系R的绕x轴转动速度的效应
     0 0 -2*md 0 0 0;
     0 2*md 0 0 0 0; 
     0 0 0 0 0 0;
     0 0 0 0 0 -imdy;
     0 0 0 0 imdy 0];
c = [0 0 2*md 0 0 0; %关于参考系R的绕y轴转动速度的效应
     0 0 0 0 0 0;
     -2*md 0 0 0 0 0; 
     0 0 0 0 0 -(imdy-imdmo);
     0 0 0 0 0 0;
     0 0 0 imdy-imdmo 0 0];
d = [0 -2*md 0 0 0 0; %关于参考系R的绕z轴转动速度的效应
     2*md 0 0 0 0 0;
     0 0 0 0 0 0; 
     0 0 0 0 -imdy 0;
     0 0 0 imdy 0 0;
     0 0 0 0 0 0];
Ced = a*diff(FAI)+b*Wx+c*Wy+d*Wz;%已经写完
end