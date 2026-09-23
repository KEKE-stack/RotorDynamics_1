%%定义字符变量
clc
clear
syms yd md imdmo imdy FAI Wx Wy Wz Xo Yo Zo u v w xita lamuda posai y;
syms u_1 v_1 w_1 xita_1 lamuda_1 posai_1;
syms u_2 v_2 w_2 xita_2 lamuda_2 posai_2;
syms Feshi_u Feshi_v Feshi_w Feshi_xita Feshi_lamuda Feshi_posai ROUeshi Seshi Leshi Iseshimo Eeshi Geshi keshimo;
syms FAI Wx Wy Wz Xo Yo Zo u v w xita lamuda posai;
syms Rmu Ymu gama beta;
syms FAI Mmu x_ z_ Kuu Kuv Kuw Kuxita Kulamuda Kuposai Kvu Kvv Kvw Kvlamuda Kwu Kwv Kww Kwxita;
syms Kwlamuda Kwposai Kposai Kxitaxita Kxitalamuda Klamudaxita Klamudalamuda Kposailamuda Kposaiposai Klamudaposai;
%%组装质量矩阵
Med_1 = DiskElementMass(md,imdmo,imdy);
Mesh_0 = ShaftElementMass(Feshi_u,Feshi_v,Feshi_w,Feshi_xita,Feshi_lamuda,Feshi_posai,ROUeshi,Seshi,Leshi);
Mesh_1 = Mesh_0;
Mesh_2 = Mesh_0;
Mero_0 = Mesh_0;
Mero_1 = Mesh_1+Med_1;
Mero_2 = Mesh_2;
Mero = blkdiag(Mero_0,Mero_1,Mero_2);
%%组装阻尼矩阵

Ced_0 = DiskElementDamping(md,imdmo,imdy,FAI,Wx,Wy,Wz);
Cesh_0 = ShaftElementDamping(FAI,Wx,Wy,Wz,Feshi_u,Feshi_v,Feshi_w,Feshi_xita,Feshi_lamuda,Feshi_posai,ROUeshi,Seshi,Leshi,Iseshimo);

%%组装刚度矩阵
Ked = DiskElementStiffness(md,imdmo,imdy,FAI,Wx,Wy,Wz);
Keshi = ShaftElementStiffness(y,FAI,Wx,Wy,Wz,Feshi_u,Feshi_v,Feshi_w,Feshi_xita,Feshi_lamuda,Feshi_posai,ROUeshi,Seshi,Leshi,Iseshimo,Eeshi,Geshi,keshimo);

%%组装外力
Fedlamuda = DiskElementForces_of_RotaryInertia(imdy,FAI);
Fed_su = DiskElementForces_of_support(yd,md,imdmo,imdy,FAI,Wx,Wy,Wz,Xo,Yo,Zo);
Feshi_lamuda = ShaftElementForces_of_RotaryInertia(FAI,Feshi_lamuda,ROUeshi,Iseshimo,Leshi);
Feshi_su = ShaftElementForces_of_support(y,FAI,Wx,Wy,Wz,Feshi_u,Feshi_v,Feshi_w,Feshi_xita,Feshi_lamuda,Feshi_posai,ROUeshi,Seshi,Leshi,Iseshimo,Xo,Yo,Zo);