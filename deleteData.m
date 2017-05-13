function deleteData(i,j)
initialization
for l=1:length(nSample)
    for ii=1:nSampleVary
%                     k
%                     l
%                     ii
        delete([dataFolder 'bIncum_f' num2str(i) '_nv' num2str(nv(j)) '_nSp' num2str(nSample(l)) '_nSpV' num2str(ii) '.mat']);
    end
end
            
            