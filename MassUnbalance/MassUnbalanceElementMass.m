function Y = MassUnbalanceElementMass(Mmu,Rmu,x_,z_)
%MassUnbalanceElementMass
%此函数返回质量不平衡质量矩阵Memu
Y = Mmu*[1 0 0 0 z_ 0;
         0 1 0 -z_ 0 x_;
         0 0 1 0 -x_ 0;
         0 -z_ 0 z_^2 0 -x_*z_;
         z_ 0 -x_ 0 Rmu^2 0;
         0 x_ 0 -x_*z_ 0 x_^2];%已检查
end
