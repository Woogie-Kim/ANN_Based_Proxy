function [] = sorttool(Property, iter,domain,NPV_base)
NPV_sort = sort(NPV_base(:,4),'descend'); % ANN
new(size(NPV_base,1),size(NPV_base,2)) = 0;

for i = 1 : size(NPV_sort,1)
    for ii = 1 : size(NPV_sort,1)
        if NPV_sort(i,1) == NPV_base(ii,4)
            new(i,1) = NPV_base(ii,1);
            new(i,2) = NPV_base(ii,2);
            new(i,3) = NPV_base(ii,3);
            new(i,4) = NPV_base(ii,4);
            new(i,5) = i;
            new(i,6) = NPV_base(ii,5);
        end
    end
end

Property = string(Property);
Property = char(Property);
prop = ["HalfLength", "Conductivity", "Spacing", "Predicted_NPV", "Rank","Predicted_Prod"];
writematrix(prop, 'NPV_Calculation.xlsx', 'Range','B1:G1','Sheet',iter);
writematrix(new, 'NPV_Calculation.xlsx', 'Range','B2:G276','Sheet',iter);

e = actxserver('Excel.Application'); % # open Activex server
ewb = e.Workbooks.Open(domain); % # open file (enter full path!)
ewb.Worksheets.Item(iter).Name = Property; % # rename zzth sheet
ewb.Save % # save to the same file
ewb.Close(false)
e.Quit
end