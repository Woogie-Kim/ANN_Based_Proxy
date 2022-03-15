function [] = scatter_NPV(filename,shape)
sheets = sheetnames(filename);
PropNum = size(sheets,1);
for z = 1 : PropNum
    ShtName = sheets(z);
    table = readmatrix(filename,'Sheet',ShtName);
    NPVresult(:,z) = table(:,4);
end
sheets = str2double(sheets);
norm_sheets = normalize(sheets,'Range');
scatter(norm_sheets,NPVresult(1,1:PropNum),'filled',shape);
end