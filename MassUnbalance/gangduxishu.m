function [Kuu,Kuv,Kuw,Kuxita,Kulamuda,Kuposai,Kvu,Kvv,Kvw,Kvlamuda,Kwu,Kwv,Kww,Kwxita,Kwlamuda,Kwposai,Kxitaxita,Kxitalamuda,Klamudaxita,Klamudalamuda,Klamudaposai,Kposailamuda,Kposaiposai] = gangduxishu(d_FAI,d_Xo,d_Yo,d_Zo,d_Wx,d_Wy,d_Wz,d_Xo_2,d_Yo_2,d_Zo_2,Wx,Wy,Wz,Rmu,x_,z_,Zo,Xo,Yo,Ymu)
%刚度系数函数的输入
%依次输入转子相对于地面的转速W在xyz方向分量，质量不平衡与轴心距离Rmu，质量不平衡有限元素向量x_，z_，转子自转转速FAI，转子绝对位置坐标Xo,Yo,Zo,质量不平衡相对转子坐标原点的距离Ymu。
Kuu = Wy^2+Wz^2;
Kuv = -d_Wz+Wx*Wy;
Kuw = d_Wy+Wx*Wz;
Kuxita = -2*x_*d_FAI*Wz-z_*Kuv;
Kulamuda = -x_*Kuw-z_*(Kuu+2*d_FAI*Wy);
Kuposai = -2*z_*d_FAI*Wz+x_*Kuv;
Kvu = d_Wz+Wx*Wy;
Kvv = Wx^2+Wz^2;
Kvw = -d_Wx+Wy*Wz;
Kvlamuda = z_*Kvu-x_*Kvw+2*d_FAI*(z_*Wx-x_*Wz);
Kwu = -d_Wy+Wx*Wz;
Kwv = d_Wx+Wy*Wz;
Kww = Wx^2+Wy^2;
Kwxita = 2*x_*d_FAI*Wx-z_*Kwv;
Kwlamuda = z_*Kwu+x_*(Kww+2*d_FAI*Wy);
Kwposai = 2*z_*d_FAI*Wx+x_*Kwv;
Kxitaxita = d_Zo_2-(x_+Xo)*Kwu-(Ymu+Yo)*Kwv+Zo*Kww+z_*(Wy^2-Wz^2)+2*(d_Xo*Wy-d_Yo*Wx)+2*z_*d_FAI*Wy;
Kxitalamuda = x_*d_Yo_2+2*x_*(d_Xo*Wz-d_Zo*Wx)+x_*(Xo*d_Wz-Zo*d_Wx)+(x_^2-z_^2)*(d_Wz-2*d_FAI*Wx)-...
              2*x_*z_*(d_Wx-2*d_FAI*Wz)-x_*(Ymu+Yo)*(Wx^2+Wz^2)+(x_*(x_+Xo)-z_^2)*Wx*Wy+x_*(2*z_+Zo)*Wy*Wz;
Klamudaxita = x_*d_Yo_2+2*x_*(d_Xo*Wz-d_Zo*Wx)+x_*(Xo*d_Wz-Zo*d_Wx)-Rmu^2*d_Wz-x_*(Ymu+Yo)*(Wx^2+Wz^2)+...
              (x_*(x_+Xo)-z_^2)*Wx*Wy+x_*(2*z_+Zo)*Wy*Wz;
Klamudalamuda = -(x_*d_Xo_2+z_*d_Zo_2)+2*(z_*d_Xo-x_*d_Zo)*Wy+2*d_Yo*(x_*Wz-z_*Wx)+(Ymu+Yo)*(x_*d_Wz-z_*d_Wx)+...
                (z_*Xo-x_*Zo)*d_Wy+x_*Xo*Wz^2+z_*Zo*Wx^2-(Ymu+Yo)*(x_*Wx+z_*Wz)*Wy+(x_*Xo+z_*Zo)*Wy^2-...
                (z_*Xo+x_*(Zo+4*z_))*Wx*Wz+(z_^2-x_^2)*(Wx-Wz);
Klamudaposai = z_*d_Yo_2+2*z_*(d_Xo*Wz-d_Zo*Wx)+z_*(Xo*d_Wz-Zo*d_Wx)-Rmu^2*d_Wx-z_*(Ymu+Yo)*(Wx^2+Wz^2)+...
              (z_*(z_+Zo)-x_^2)*Wy*Wz+z_*(2*x_+Xo)*Wx*Wy;
Kposailamuda = z_*d_Yo_2+2*z_*(d_Xo*Wz-d_Zo*Wx)+z_*(Xo*d_Wz-Zo*d_Wx)+(x_^2-z_^2)*(d_Wx-2*d_FAI*Wz)+...
              2*x_*z_*(d_Wz+2*d_FAI*Wx)-z_*(Ymu+Yo)*(Wx^2+Wz^2)+(z_*(z_+Zo)-x_^2)*Wy*Wz+z_*(2*x_+Xo)*Wx*Wy;
Kposaiposai = d_Xo_2+(z_+Zo)*Kuw+(Ymu+Yo)*Kuv-Xo*Kuu+x_*(Wx^2-Wy^2)+2*(d_Zo*Wy-d_Yo*Wz)-2*x_*d_FAI*Wy;%已检查
end

