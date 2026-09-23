function y = ShaftElementMass(min,max,Form_eshi_u,Form_eshi_v,Form_eshi_w,Form_eshi_xita,Form_eshi_lamuda,Form_eshi_posai,ROUeshi,Seshi,Iseshimo)
%ShaftElementMass   
%此函数返回轴有限元的单元质量矩阵，该矩阵由轴有限元的形状位置函数积分而成
%单元质量矩阵Meshi的大小为12 x 12。
a = ROUeshi*Seshi*int(Form_eshi_u.'*Form_eshi_u+Form_eshi_v.'*Form_eshi_v+Form_eshi_w.'*Form_eshi_w,min,max);%Meshitr，积分书写形式与r
b = ROUeshi*Iseshimo*int(Form_eshi_xita.'*Form_eshi_xita+2*(Form_eshi_lamuda.'*Form_eshi_lamuda)+Form_eshi_posai.'*Form_eshi_posai,min,max);%Meshiro
y = a+b;%已经写完
end