function y = C_rolling_bearing(c)
%rolling_bearing   
%此函数返回轴承节点的刚度矩阵
y = [c 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 c 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0];%已写完
end