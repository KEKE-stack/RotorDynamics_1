function y = ShaftElementDamping(min,max,d_FAI,Wx,Wy,Wz,Feshi_u,Feshi_v,Feshi_w,Feshi_xita,Feshi_lamuda,Feshi_posai,ROUeshi,Seshi,Iseshimo)
%ShaftElementDamping
%此函数返回轴有限元的单元阻尼矩阵  自转陀螺效应和参考系旋转产生的速度耦合项
%该矩阵由轴有限元的形状位置函数积分而成
%单元阻尼矩阵Ceshi(t)的大小为12 x 12。
a = 2*ROUeshi*Iseshimo*int(Feshi_posai.'*Feshi_xita-Feshi_xita.'*Feshi_posai,min,max);%Ceshig
b = 2*ROUeshi*Seshi*int(Feshi_w.'*Feshi_v-Feshi_v.'*Feshi_w,min,max)...
    +2*ROUeshi*Iseshimo*int(Feshi_posai.'*Feshi_lamuda-Feshi_lamuda.'*Feshi_posai,min,max);%Ceshi,suWx
c = 2*ROUeshi*Seshi*int(Feshi_u.'*Feshi_w-Feshi_w.'*Feshi_u,min,max);%Ceshi,suWy
d = 2*ROUeshi*Seshi*int(Feshi_v.'*Feshi_u-Feshi_u.'*Feshi_v,min,max)...
    +2*ROUeshi*Iseshimo*int(Feshi_lamuda.'*Feshi_xita-Feshi_xita.'*Feshi_lamuda,min,max);%Ceshi,suWz
y = a*d_FAI+b*Wx+c*Wy+d*Wz;%已检查
end
%%
%这部分来自转子的三个欧拉角造成的陀螺效应a
%以及支座的微小运动参考系虚度耦合 b c d主要是科里奥利加速度项
%一台电机固定在实验台上，转轴高速旋转，此时 d_FAI 不为零，而三个支座角速度都为零，
%轴单元仍有 a*d_FAI 的陀螺项。若把整台电机安装到发生俯仰或偏航的运动平台上，支座角速度也不再为零，于是额外出现 b*Wx+c*Wy+d*Wz
%b、d 还多了一部分？截面本身也会转动，但 Timoshenko 梁还考虑截面的转动惯性，因此还需要 \(\theta、\lambda、\psi\)
%三个转动自由度（转子的。