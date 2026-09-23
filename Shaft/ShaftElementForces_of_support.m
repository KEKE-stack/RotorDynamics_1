function Y = ShaftElementForces_of_support(min,max,Leshi,d_FAI,y,Wx,d_Wx,Wy,d_Wy,Wz,d_Wz,Form_eshi_u,Form_eshi_v,Form_eshi_w,Form_eshi_xita,Form_eshi_lamuda,...
    Feshi_posai,ROUeshi,Seshi,Iseshimo,Xo,d_Xo,d_Xo_2,Yo,d_Yo,d_Yo_2,Zo,d_Zo,d_Zo_2)
%ShaftElementForces_of_support
%此函数返回参考系运动产生的单元力Feshi，su(t)=-a*diff(FAI,2)
y_ = y/Leshi;
a = ROUeshi*Seshi*int(Form_eshi_u.',min,max);%Veshi,su_u
b = ROUeshi*Seshi*int(Form_eshi_v.',min,max);%Veshi,su_v 要注意Y方向的形状函数是常数，不需要积分。
c = ROUeshi*Seshi*int(Form_eshi_w.',min,max);%Veshi,su_w
d = ROUeshi*Seshi*Leshi*int(Form_eshi_w.'*y_,min,max);%Veshi,su_yw
e = ROUeshi*Seshi*Leshi*int(Form_eshi_u.'*y_,min,max);%Veshi,su_yu
f = ROUeshi*Seshi*Leshi*int(Form_eshi_v.'*y_,min,max);%Veshi,su_yv
g = ROUeshi*Iseshimo*int(Form_eshi_xita.',min,max);%Veshi,su_xita
h = 2*ROUeshi*Iseshimo*int(Form_eshi_lamuda.',min,max);%Veshi,su_lamuda
i = ROUeshi*Iseshimo*int(Feshi_posai.',min,max);%Veshi,su_posai
j = 2*ROUeshi*Iseshimo*int(Feshi_posai.',min,max);%Veshi,su_yposai
k = 2*ROUeshi*Iseshimo*int(Form_eshi_xita.',min,max);%Veshi,su_yxita
Y = -a*(d_Xo_2+2*d_Zo*Wy-2*d_Yo*Wz+Zo*(d_Wy+Wx*Wz)-Yo*(d_Wz-Wx*Wy)-Xo*(Wy^2+Wz^2))...
    -b*(d_Yo_2-2*d_Zo*Wx+2*d_Xo*Wz-Zo*(d_Wx-Wy*Wz)+Xo*(d_Wz+Wx*Wy)-Yo*(Wx^2+Wz^2))...
    -c*(d_Zo_2+2*d_Yo*Wx-2*d_Xo*Wy+Yo*(d_Wx+Wy*Wz)-Xo*(d_Wy-Wx*Wz)-Zo*(Wx^2+Wy^2))...
    -d*(d_Wx+Wy*Wz)+e*(d_Wz-Wx*Wy)+f*(Wx^2+Wz^2)-g*(d_Wx+Wy*Wz)....
    -h*(d_Wy)-i*(d_Wz-Wx*Wy)-j*(d_FAI*Wx+Wx*Wy)+k*(d_FAI*Wz+Wy*Wz);%已检查
end


