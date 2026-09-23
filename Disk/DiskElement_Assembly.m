%%转盘启动器，还未输入具体变量，全部变量用符号变量表示
clc
clear
DETA_ed_2  = [u_2;v_2;w_2;xita_2;lamuda_2;posai_2];
DETA_ed_1  = [u_1;v_1;w_1;xita_1;lamuda_1;posai_1];
DETA_ed_0  = [u;v;w;xita;lamuda;posai];
Med = DiskElementMass(md,imdmo,imdy);
Ced = DiskElementDamping(md,imdmo,imdy,FAI,Wx,Wy,Wz);
Ked = DiskElementStiffness(md,imdmo,imdy,FAI,Wx,Wy,Wz);
Fedlamuda = DiskElementForces_of_RotaryInertia(imdy,FAI);
Fed_su = DiskElementForces_of_support(yd,md,imdmo,imdy,FAI,Wx,Wy,Wz,Xo,Yo,Zo);
ed1 = Med*DETA_ed_2+Ced*DETA_ed_1+Ked*DETA_ed_0-Fedlamuda-Fed_su;%节点1--转盘