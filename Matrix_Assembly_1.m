function Matrix_all = Matrix_Assembly_1(Matrix_1,Matrix_2,Matrix_3,Matrix_4,Matrix_5,Matrix_6,Matrix_7,Matrix_8,Matrix_9,Matrix_10,Matrix_11,Matrix_12)
%%此函数用于装配总矩阵大小为78 x 78
A = zeros(6,6);
Matrix_1_3 = blkdiag(Matrix_1,Matrix_3,Matrix_5,Matrix_7,Matrix_9,Matrix_11,A);
Matrix_2_4 = blkdiag(A,Matrix_2,Matrix_4,Matrix_6,Matrix_8,Matrix_10,Matrix_12);
Matrix_all = Matrix_1_3+Matrix_2_4;
end