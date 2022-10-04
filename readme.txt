模型配置参数：
修改位置：SolveParameter 25-27行的ExcelFileName和ExcelFileDir

一·角度驱动
ExcelFileDir = 'Parameter File\Pendulum Angle Drive';
	模型1：刚体模型
ExcelFileName = 'Rigid Beam Pendulum Angle Drive';
	模型2：1段Timoshenko梁
ExcelFileName = 'Timoshenko Beam Pendulum Angle Drive - 1 Segments';
	模型3：3段Timoshenko梁
ExcelFileName = 'Timoshenko Beam Pendulum Angle Drive - 3 Segments';
	模型4：5段Timoshenko梁
ExcelFileName = 'Timoshenko Beam Pendulum Angle Drive - 5 Segments';
	模型5：10段Timoshenko梁
ExcelFileName = 'Timoshenko Beam Pendulum Angle Drive - 10 Segments';
	模型6：1段Cubic Spline梁
ExcelFileName = 'Cubic Spline Beam Pendulum Angle Drive - 1 Segments';
	模型7：3段Cubic Spline梁
ExcelFileName = 'Cubic Spline Beam Pendulum Angle Drive - 3 Segments';
	模型8：5段Cubic Spline梁
ExcelFileName = 'Cubic Spline Beam Pendulum Angle Drive - 5 Segments';
	模型9：10段Cubic Spline梁
ExcelFileName = 'Cubic Spline Beam Pendulum Angle Drive - 10 Segments';

二·转矩驱动
ExcelFileDir = 'Parameter File\Pendulum Moment Drive';
	模型1：刚体模型
ExcelFileName = 'Rigid Beam Pendulum Axis Drive';
	模型2：1段Timoshenko梁
ExcelFileName = 'Timoshenko Beam Pendulum Axis Drive - 1 Segments';
	模型3：3段Timoshenko梁
ExcelFileName = 'Timoshenko Beam Pendulum Axis Drive - 3 Segments';
	模型4：5段Timoshenko梁
ExcelFileName = 'Timoshenko Beam Pendulum Axis Drive - 5 Segments';
	模型5：10段Timoshenko梁
ExcelFileName = 'Timoshenko Beam Pendulum Axis Drive - 10 Segments';
	模型6：1段Cubic Spline梁
ExcelFileName = 'Cubic Spline Beam Pendulum Axis Drive - 1 Segments';
	模型7：3段Cubic Spline梁
ExcelFileName = 'Cubic Spline Beam Pendulum Axis Drive - 3 Segments';
	模型8：5段Cubic Spline梁
ExcelFileName = 'Cubic Spline Beam Pendulum Axis Drive - 5 Segments';
	模型9：10段Cubic Spline梁
ExcelFileName = 'Cubic Spline Beam Pendulum Axis Drive - 10 Segments';

本程序已经生成了上述的实验结果
可以使用Result_Reproduce.m来调用
且PostProcessing.m用来生成末端节点运动对比图