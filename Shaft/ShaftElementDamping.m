function y = ShaftElementDamping(min,max,d_FAI,Wx,Wy,Wz,Feshi_u,Feshi_v,Feshi_w,Feshi_xita,Feshi_lamuda,Feshi_posai,ROUeshi,Seshi,Iseshimo)
%ShaftElementDamping
%此函数返回轴有限元的单元阻尼矩阵
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