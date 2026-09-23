function Y = MassUnbalanceElementForces_of_support(d_FAI,d_Xo,d_Yo,d_Zo,d_Xo_2,d_Yo_2,d_Zo_2,d_Wx,d_Wy,d_Wz,Mmu,Ymu,Xo,Yo,Zo,Wx,Wy,Wz,x_,z_)
%MassUnbalanceElementForces_of_support
%此函数返回质量不平衡钻杆运动引起的力矩阵Femu_su
Fu = d_Xo_2+2*(d_Zo*Wy-d_Yo*Wz)-(x_+Xo)*(Wy^2+Wz^2)-(Ymu+Yo)*(d_Wz-Wx*Wy)...
    +(z_+Zo)*(d_Wy+Wx*Wz)-2*x_*d_FAI*Wy;
Fv = d_Yo_2+2*(d_Xo*Wz-d_Zo*Wx)+(x_+Xo)*(d_Wz+Wx*Wy)-(Ymu+Yo)*(Wx^2+Wz^2)...
    -(z_+Zo)*(d_Wx-Wy*Wz)+2*d_FAI*(x_*Wx+z_*Wz);
Fw = d_Zo_2+2*(d_Yo*Wx-d_Xo*Wy)-(x_+Xo)*(d_Wy-Wx*Wz)+(Ymu+Yo)*(d_Wx+Wy*Wz)...
    -(z_+Zo)*(Wx^2+Wy^2)-2*z_*d_FAI*Wy;
Fxita = -z_*Fv;
Flamuda = z_*d_Xo_2-x_*d_Zo_2+2*((x_*d_Xo+z_*d_Zo)*Wy-d_Yo*(x_*Wx+z_*Wz))+Wy^2*(x_*Zo-z_*Xo)...
        +(x_+Xo)*(x_*(d_Wy-Wx*Wz)-z_*Wz^2)+(z_+Zo)*(z_*(d_Wy+Wx*Wz)+x_*Wx^2)...
        -(Ymu+Yo)*(x_*(d_Wx+Wy*Wz)+z_*(d_Wz-Wx*Wy));
Fposai = x_*Fv;
Y = -Mmu*[Fu;
          Fv;
          Fw;
          Fxita;
          Flamuda;
          Fposai];%已检查
end