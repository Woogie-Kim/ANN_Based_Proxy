%%
h = figure;
npvbox('COND.xlsx',275/11);
saveas(h,'cond_box.png');
ylim([0 15000])
xlabel('Hydraulic Fracture Conductivity (md*ft)')
ylabel('Cumulative Gas Production (MMscf)')

h = figure;
npvbox('HALF.xlsx',275/5);
ylim([0 15000])
xlabel('Hydraulic Fracture Half-Length (ft)')
ylabel('Cumulative Gas Production (MMscf)')
saveas(h,'half_box.png');
h = figure;
npvbox('SPACING.xlsx',275/5);
ylim([0 15000])
xlabel('Hydraulic Fracture Spacing (ft)')
ylabel('Cumulative Gas Production (MMscf)')
saveas(h,'spacing_box.png');
close all
function [] = npvbox(filename, RankBound)
sheets = sheetnames(filename);
PropNum = size(sheets,1);
for z = 1 : PropNum
    ShtName = sheets(z);
    table = readmatrix(filename,'Sheet',ShtName);
    NPVresult(:,z) = table(:,4);
end
NPVresult = NPVresult *1e-6;
boxplot(NPVresult(1:RankBound,1:PropNum),'Labels',sheets)
end
