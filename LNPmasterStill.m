% LNPmaster.m is a script that varies the parameters of the filter and nonlinearity to plot predictive information

addSubDirs;
makeosmex;

trials = 1000;
time = 100;
figures = 0;

slopes = linspace(.5,2,4);
points = linspace(0,2,8);
filterLengths = linspace(0,50,10);
variances = linspace(0,2,8);

predictiveInfo_w = zeros(length(slopes),length(points),length(filterLengths),length(variances));
predictiveInfo_p = zeros(length(slopes),length(points),length(filterLengths),length(variances));


for slope = 1:length(slopes)
    for point = 1:length(points)
        for filterLength = 1:length(filterLengths)
            for variance = 1:length(variances)
                [pred,~,~,~] = LNPpredictionStill(trials, time, figures, filterLength, point, slope, variance);
                pred_w = pred(:,1);
                pred_p = pred(:,2);
                predictiveInfo_w(slope,point,filterLength,variance) = mean(pred_w(1:round(time/2)));
                predictiveInfo_p(slope,point,filterLength,variance) = mean(pred_p(1:round(time/2)));
            end
        end
    end
end

save LNPpredictions.mat

