function [] = bitbit(inputfile,outputfile)
NPV_base = xlsread(inputfile);
NPV_sort(:,1) = sort(NPV_base(:,4),'descend'); % ANN
NPV_sort(:,2) = sort(NPV_base(:,5),'descend'); % Simulation

new(size(NPV_base,1),size(NPV_base,2)) = 0;

for i = 1 : size(NPV_sort,1)
    for ii = 1 : size(NPV_sort,1)
        if NPV_sort(i,1) == NPV_base(ii,4)
            new(i,1) = NPV_base(ii,1);
            new(i,2) = NPV_base(ii,2);
            new(i,3) = NPV_base(ii,3);
            new(i,4) = NPV_base(ii,4);
            new(i,5) = NPV_base(ii,5);
            new(i,6) = NPV_base(ii,6);
            new(i,7) = i;
        end
    end
end

for k = 1 : size(NPV_sort,1)
    for kk = 1 : size(NPV_sort,1)
        if NPV_sort(k,2) == new(kk,5)
            new(kk,8) = k;
        end
    end
end
prop = ["HalfLength", "Conductivity", "Spacing", "Predicted_NPV","Simulation_NPV","Error","Rank_ANN", "Rank_Sim"];
writematrix(prop, outputfile, 'Range','B1:I1');
writematrix(new, outputfile, 'Range','B2:I276');
end
