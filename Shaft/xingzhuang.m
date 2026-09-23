function [Form_eshi_u,Form_eshi_v,Form_eshi_w,Form_eshi_xita,Form_eshi_lamuda,Form_eshi_posai] = xingzhuang(y,l,E,I,k,G,A)
%形状函数的输入
%依次输入符号变量表示的任意距离y、轴单元的长度、杨氏模量、惯性矩、修正系数、剪切模量、截面面积。
kesai = y/l;
fai = 12*E*I/(k*G*A*l^2);
t1 = (1-3*kesai^2+2*kesai^3+(1-kesai)*fai)/(1+fai);
t2 = l*(kesai-2*kesai^2+kesai^3+(kesai-kesai^2)*fai/2)/(1+fai);
t3 = (3*kesai^2-2*kesai^3+kesai*fai)/(1+fai);
t4 = l*(-kesai^2+kesai^3-(kesai-kesai^2)*fai/2)/(1+fai);
t5 = 1-kesai;
t6 = kesai;
rou1 = 6*(-kesai+kesai^2)/(l*(1+fai));
rou2 = (1-4*kesai+3*kesai^2+(1-kesai)*fai)/(1+fai);
rou3 = 6*(kesai-kesai^2)/(l*(1+fai));
rou4 = (-2*kesai+3*kesai^2+kesai*fai)/(1+fai);
rou5 = 1-kesai;
rou6 = kesai;
Form_eshi_u = [t1 0 0 0 0 -t2 t3 0 0 0 0 -t4]; 
Form_eshi_v = [0 t5 0 0 0 0 0 t6 0 0 0 0];
Form_eshi_w = [0 0 t1 t2 0 0 0 0 t3 t4 0 0];
Form_eshi_xita = [0 0 rou1 rou2 0 0 0 0 rou3 rou4 0 0];
Form_eshi_lamuda = [0 0 0 0 rou5 0 0 0 0 0 rou6 0];
Form_eshi_posai = [-rou1 0 0 0 0 rou2 -rou3 0 0 0 0 rou4];%已检查
end

