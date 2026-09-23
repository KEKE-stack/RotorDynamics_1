function y = ShaftElementForces_of_Weight(min,max,beta,gama,Form_eshi_u,Form_eshi_v,Form_eshi_w,ROUeshi,Seshi)
%ShaftElementForces_of_Weight  
%此函数返回转轴重力产生的广义力FeshiWr。
%y = -9.81*ROUeshi*Seshi*int(-Form_eshi_u.'*cos(beta)*sin(gama)+Form_eshi_v.'*sin(beta)+Form_eshi_w.'*cos(beta)*cos(gama),min,max);%已检查
y = 0*ROUeshi*Seshi*int(-Form_eshi_u.'*cos(beta)*sin(gama)+Form_eshi_v.'*sin(beta)+Form_eshi_w.'*cos(beta)*cos(gama),min,max);%设重力加速度为0
end                                                                                                                                                  