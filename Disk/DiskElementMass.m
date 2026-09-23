function Med = DiskElementMass(md,imdmo,imdy)
%DiskElementMass   
%此函数返回质量为md、(md,imdmo,imdy)
%平均转动惯量为imdmo、
%绕Oy主轴的主惯性矩为imdy的转盘的节点质量矩阵Med,
%节点质量矩阵Med的大小为6 x 6。
a = [md 0 0 0 0 0; %平动项
     0 md 0 0 0 0;
     0 0 md 0 0 0; 
     0 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0];
b = [0 0 0 0 0 0; %转动项
     0 0 0 0 0 0;
     0 0 0 0 0 0; 
     0 0 0 imdmo 0 0;
     0 0 0 0 imdy 0;
     0 0 0 0 0 imdmo];
Med = a+b;%已经写完
end