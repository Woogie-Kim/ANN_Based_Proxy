function [] = plot_NPV(filename)
sheets = sheetnames(filename);
PropNum = size(sheets,1);
for z = 1 : PropNum
    ShtName = sheets(z);
    table = readmatrix(filename,'Sheet',ShtName);
    NPVresult(:,z) = table(:,4);
end
s = rng;
rng(s);
r1 = rand(1,3);
sheets = str2double(sheets);
norm_sheets = normalize(sheets,'Range');
plot(norm_sheets,NPVresult(1,1:PropNum),'-o',...
    'MarkerEdgeColor',r1,...
    'Color',r1,...
    'MarkerFaceColor',r1)
end
