Folding Boom 3DoF模型介绍
1. 概述
此模型是一个3自由度的Folding Boom最小模型，自由度的选择为：
1）转台的转角psi
2）第一个长杆与水平方向的夹角phi1
3）第二根长杆与第一根长杆的夹角phi2
广义速度就是相对应广义坐标的一阶导数。
模型由3个控制变量来控制，分别为：
1）转台的扭矩ut
2）下部液压缸的液压力u1
3）上部液压缸的液压力u2

2.相关函数
模型地址：
Multibody Dynamics Model-MatLab Programm\Specified Model\3 DoF Folding Boom
请在Multibody Dynamics Model-MatLab Programm目录下，并且加载所有子模块后运行。
测试文件：FoldingBoom_3DoF_Test.m
动力学方程：FoldingBoom_Dynamic_func.m


3.模型测试
此模型经过
1）无外力自由下落测试
2）控制变量u=[0;1e6;1e6]恒定驱动测试
测试均符合预期