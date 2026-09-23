function Y = MassUnbalanceElementDamping(d_FAI,Mmu,x_,z_,Wx,Wy,Wz)
%MassUnbalanceElementDamping
%此函数返回质量不平衡阻尼矩阵Cemu(t)
a = 2*Mmu*[0 0 0 0 -x_ 0;
           0 0 0 x_ 0 z_;
           0 0 0 0 -z_ 0;
           0 0 0 -x_*z_ 0 -z_^2;
           0 0 0 0 0 0;
           0 0 0 x_^2 0 x_*z_];
b = 2*Mmu*[0 -Wz Wy z_*Wz -x_*Wy -x_*Wz;
           Wz 0 -Wx 0 x_*Wx+z_*Wz  0;
           -Wy Wx 0 -z_*Wx -z_*Wy x_*Wx;
           -z_*Wz 0 z_*Wx 0 -z_*(x_*Wx+z_*Wz) 0;
           x_*Wy -(x_*Wx+z_*Wz) z_*Wy z_*(x_*Wx+z_*Wz) 0 -x_*(x_*Wx+z_*Wz);
           x_*Wz 0 -x_*Wx 0 x_*(x_*Wx+z_*Wz) 0];
Y = a*d_FAI+b;%已检查
end
