function Fed_su = DiskElementForces_of_support(yd,md,imdmo,imdy,FAI,Wx,Wy,Wz,Xo,Yo,Zo)
%DiskElementStiffnessDiskElementForces_of_support   
%此函数返回质量为md、(md,imdmo,imdy,FAI,Wx,Wy,Wz,Xo,Yo,Zo)
%平均转动惯量为imdmo、
%绕Oy主轴的主惯性矩为imdy的转盘的节点支撑力矩阵y=Fed_su(t)，
%节点刚度矩阵Ked(t)的大小为6 x 1。
a = [md; %关于转盘x方向上的平动u和参考系R的运动的效应
     0;
     0; 
     0;
     0;
     0];
b = [0; %关于转盘y方向上的平动v和参考系R的运动的效应
     md;
     0; 
     0;
     0;
     0];
c = [0; %关于转盘z方向上的平动w和参考系R的运动的效应
     0;
     md; 
     0;
     0;
     0];
d = yd*[0; %关于转盘初始位置yd、转盘z方向上的平动w和参考系R的运动的效应
        0;
        md; 
        0;
        0;
        0];
e = yd*[md; %关于转盘初始位置yd、转盘x方向上的平动u和参考系R的运动的效应
        0;
        0; 
        0;
        0;
        0];
f = yd*[0; %关于转盘初始位置yd、转盘y方向上的平动v和参考系R的运动的效应
        md;
        0; 
        0;
        0;
        0];
g = [0; %关于转盘绕x轴的转动xita和参考系R的运动的效应
     0;
     0; 
     imdmo;
     0;
     0 ];
h = [0; %关于转盘绕y轴的转动lamuda和参考系R的运动的效应
     0;
     0; 
     0;
     imdy;
     0 ];
i = [0; %关于转盘绕z轴的转动posai和参考系R的运动的效应
     0;
     0; 
     0;
     0;
     imdmo ];
j = [0; %关于转子转动速度diff(XITA)、转盘绕z轴的转动posai和参考系R的运动的效应
     0;
     0; 
     0;
     0;
     imdy ];
k = [0; %关于转子转动速度diff(XITA)、转盘绕x轴的转动xita和参考系R的运动的效应
     0;
     0; 
     imdy;
     0;
     0 ];
 Fed_su = -a*(diff(Xo,2)+2*diff(Zo)*Wy-2*diff(Yo)*Wz+Zo*(diff(Wy)+Wx*Wz)-Yo*(diff(Wz)-Wx*Wy)-Xo*(Wy^2+Wz^2))...
          -b*(diff(Yo,2)-2*diff(Zo)*Wx+2*diff(Xo)*Wz-Zo*(diff(Wx)-Wy*Wz)+Xo*(diff(Wz)+Wx*Wy)-Yo*(Wx^2+Wz^2))...
          -c*(diff(Zo,2)+2*diff(Yo)*Wx-2*diff(Xo)*Wy+Yo*(diff(Wx)+Wy*Wz)-Xo*(diff(Wy)-Wx*Wz)-Zo*(Wx^2+Wy^2))...
          -d*(diff(Wx)+Wy*Wz)+e*(diff(Wz)-Wx*Wy)+f*(Wx^2+Wz^2)-g*(diff(Wx)+Wy*Wz)....
          -h*(diff(Wy))-i*(diff(Wz)-Wx*Wy)-j*(diff(FAI)*Wx+Wx*Wy)+k*(diff(FAI)*Wz+Wy*Wz);%已经写完
end