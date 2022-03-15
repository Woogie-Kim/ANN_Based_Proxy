function [] = AutoSave(h,MPERM,NFPERM,MPORO,NFPORO,PROPERTY)

if PROPERTY == "MPERM"
    saveas(h,sprintf('MPERMCHANGE/optimal%.4f.png',MPERM))
elseif PROPERTY == "NFPERM"
    saveas(h,sprintf('NFPERMCHANGE/optimal%.3f.png',NFPERM))
elseif PROPERTY == "MPORO"
    saveas(h,sprintf('MPOROCHANGE/optimal%.2f.png',MPORO))
elseif PROPERTY == "NFPORO"
    saveas(h,sprintf('NFPOROCHANGE/optimal%.2f.png',NFPORO))
end
close all