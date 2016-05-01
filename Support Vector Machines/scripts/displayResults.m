function displayResults(resultAccuracy,resultErrorRate,kernel,col)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if(kernel==1)
    r = 'd';
else
    r= 'sigma';
end
    

f1 = figure('Position',[440 500 461 146]);

% Create the column and row names in cell arrays
cnames = {sprintf('%s=%d',r,col(1)),sprintf('%s=%d',r,col(2)),sprintf('%s=%d',r,col(3))};
rnames = {'c=1','c=10','c=100','c=1000'};

% Create the uitable
t1 = uitable(f1,'Data',resultAccuracy,...
    'ColumnName',cnames,...
    'RowName',rnames);
% Set width and height
t1.Position(3) = t1.Extent(3);
t1.Position(4) = t1.Extent(4);


f2 = figure('Position',[440 500 461 146]);

% Create the column and row names in cell arrays

cnames = {sprintf('%s=%d',r,col(1)),sprintf('%s=%d',r,col(2)),sprintf('%s=%d',r,col(3))};
rnames = {'c=1','c=10','c=100','c=1000'};

% Create the uitable
t2 = uitable(f2,'Data',resultErrorRate,...
    'ColumnName',cnames,...
    'RowName',rnames);
% Set width and height
t2.Position(3) = t2.Extent(3);
t2.Position(4) = t2.Extent(4);

end

