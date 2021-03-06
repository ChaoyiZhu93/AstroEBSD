% RADARPLOT spiderweb or radar plot
% radarPlot(P) Make a spiderweb or radar plot using the columns of P as datapoints.
%  P is the dataset. The plot will contain M dimensions(or spiderweb stems)
%  and N datapoints (which is also the number of columns in P). Returns the
%  axes handle
%
% radarPlot(P, ..., lineProperties) specifies additional line properties to be
% applied to the datapoint lines in the radar plot
%
% h = radarPlot(...) returns the handles to the line objects.
function varargout = radarPlot(filled, P, minV,maxV,labels,ticknum,varargin)

%%% Get the number of dimensions and points
[M, N] = size(P);

%%% Plot the axes
% Radial offset per axis
th = (2*pi/M)*(ones(2,1)*(M:-1:1));
% Axis start and end
r = [0;1]*ones(1,M);
% Conversion to cartesian coordinates to plot using regular plot.
[x,y] = pol2cart(th, r);
hLine = line(x, y,...
    'LineWidth', 0.25,...
    'Color', [1, 1, 1]*0  );

for i = 1:numel(hLine)
    set(get(get(hLine(i),'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude line from legend
end

toggle = ~ishold;

if toggle
    hold on
end

%%% Plot axes isocurves
% Radial offset per axis
th = (2*pi/M)*(ones(ticknum,1)*(M:-1:1));
% Axis start and end
r = (linspace(0.1, 0.9, ticknum)')*ones(1,M);
% Conversion to cartesian coordinates to plot using regular plot.
[x,y] = pol2cart(th, r);
hLine = line([x, x(:,1)]', [y, y(:,1)]',...
    'LineStyle','-','LineWidth', 0.5,...
    'Color', [1, 1, 1]*0.5  );

[x2,y2] = pol2cart(th+0.05, r+0.05);
text(x2,y2,num2str(maxV),'HorizontalAlignment','center')

for i = 1:numel(hLine)
    set(get(get(hLine(i),'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude line from legend
end


%%% Insert axis labels

% Compute minimum and maximum per axis
%minV = min(P,[],2);
%maxV = max(P,[],2);
for j = 1:M
    % Generate the axis label
    msg = sprintf('x_{%d} = %5.2f ... %5.2f',...
        j, minV(j), maxV(j));
    [mx, my] = pol2cart( th(1, j), 1.1);
    text(mx, my, labels{j},'HorizontalAlignment','center');
end
axis([-1,1,-1,1]*1.5)

% Hold on to plot data points
hold on

% Radius
R = 0.8*((P - (minV*ones(1,N)))./((maxV-minV)*ones(1,N))) + 0.1;
R = [R; R(1,:)];
Th = (2*pi/M) * ((M:-1:0)'*ones(1,N));

% polar(Th, R)
[X, Y] = pol2cart(Th, R);

if filled==1
h = fill(X, Y, varargin{:});
axis([-1,1,-1,1])
axis square
axis off
end

if filled==0
h = plot(X, Y, varargin{:});
axis([-1,1,-1,1])
axis square
axis off
end

if toggle
    hold off
end

if nargout > 0 
    varargout{1} = h;
end