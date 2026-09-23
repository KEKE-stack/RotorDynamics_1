function Y = MassUnbalanceElementStiffness(d_FAI,d_FAI_2,Rmu,Mmu,x_,z_,Kuu,Kuv,Kuw,Kuxita,Kulamuda,Kuposai,Kvu,Kvv,Kvw,Kvlamuda,Kwu,Kwv,Kww,Kwxita,Kwlamuda,Kwposai,Kxitaxita,Kxitalamuda,Klamudaxita,Klamudalamuda,Kposailamuda,Kposaiposai,Klamudaposai)
%MassUnbalanceElementStiffness
%此函数返回质量不平衡刚度矩阵Kemu(t)大小为6 x 6
a = Mmu*[0 0 0 0 -x_ 0;
         0 0 0 x_ 0 z_;
         0 0 0 0 -z_ 0;
         0 0 0 0 0 0;
         0 0 0 0 0 0;
         0 0 0 Rmu^2 0 0];
b = Mmu*[0 0 0 0 -z_ 0;
         0 0 0 z_ 0 -x_;
         0 0 0 0 x_ 0;
         0 0 0 0 0 0 ;
         0 0 0 0 0 0;
         0 0 0 0 0 0];
c = Mmu*[-Kuu Kuv Kuw Kuxita Kulamuda Kuposai;
         Kvu -Kvv Kvw z_*Kvv Kvlamuda -x_*Kvv;
         Kwu Kwv -Kww Kwxita Kwlamuda Kwposai;
         -z_*Kvu z_*Kvv -z_*Kvw z_*Kxitaxita Kxitalamuda z_*Kposaiposai;
         -(x_*Kwu+z_*Kuu) -x_*Kwv+z_*Kuv x_*Kwu+z_*Kuu Klamudaxita Klamudalamuda Klamudaposai;
         x_*Kvu -x_*Kvv x_*Kvw z_*Kposaiposai Kposailamuda -x_*Kposaiposai];
Y = a*d_FAI_2+b*d_FAI^2+c;%已检查
end