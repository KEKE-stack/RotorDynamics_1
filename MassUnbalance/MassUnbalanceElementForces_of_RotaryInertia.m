function Y = MassUnbalanceElementForces_of_RotaryInertia(diff_FAI,d_FAI_2,Mmu,Rmu,x_,z_)
%MassUnbalanceElementForces_of_RotaryInertia
%此函数返回质量不平衡惯性力矩阵Femu(t)
a = -Mmu*[z_;
          0;
          -x_;
          0;
          Rmu^2;
          0];
b = Mmu*[x_;
          0;
          z_;
          0;
          0;
          0]; 
Y = a*d_FAI_2+b*diff_FAI^2;%已检查
end
