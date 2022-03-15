function [] = npvbox(filename, RankBound)
sheets = sheetnames(filename);
PropNum = size(sheets,1);
for z = 1 : PropNum
    ShtName = sheets(z);
    table = readmatrix(filename,'Sheet',ShtName);
    NPVresult(:,z) = table(:,4);
end
boxplot(NPVresult(1:RankBound,1:PropNum),'Labels',sheets)
end