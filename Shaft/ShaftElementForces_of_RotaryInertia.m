function y = ShaftElementForces_of_RotaryInertia(min,max,d_FAI_2,Form_esh1_lamuda,ROUeshi,Iseshimo)
%ShaftElementMass   
%此函数返回轴有限元的单元惯性力y=Feshi_lamuda(t)
a = 2*ROUeshi*Iseshimo*int(Form_esh1_lamuda.',min,max);
y = -a*d_FAI_2;
end