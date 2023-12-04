%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: Z:\MSc Data Science Python\Machine Learning\ML Project\MLdataset.csv
%
% Auto-generated by MATLAB on 09-Nov-2023 13:04:57

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 33);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["fifa_version", "short_name", "club_name", "club_position", "attacking_crossing", "attacking_finishing", "attacking_heading_accuracy", "attacking_short_passing", "attacking_volleys", "skill_dribbling", "skill_curve", "skill_fk_accuracy", "skill_long_passing", "skill_ball_control", "movement_acceleration", "movement_sprint_speed", "movement_agility", "movement_reactions", "movement_balance", "power_shot_power", "power_jumping", "power_stamina", "power_strength", "power_long_shots", "mentality_aggression", "mentality_interceptions", "mentality_positioning", "mentality_vision", "mentality_penalties", "mentality_composure", "defending_marking_awareness", "defending_standing_tackle", "defending_sliding_tackle"];
opts.VariableTypes = ["double", "string", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "short_name", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["short_name", "club_name", "club_position"], "EmptyFieldRule", "auto");

% Import the data
MLdataset = readtable("Z:\MSc Data Science Python\Machine Learning\ML Project\Datasets\MLdataset.csv", opts);


%% Clear temporary variables
clear opts

% Extract the value of the club position to show the distribution

% Extract column from dataset
position = MLdataset.club_position;
% pos_count shows the frequency of each position
pos_count = tabulate(position);
% Extract labels from my dataset
labels = pos_count(:,1);
counts = cell2mat(pos_count(:,2));

% calculate percentage for every position
xPercent = counts / sum(counts) * 100;
newLabels = [];
for i=1:length(counts)
    newLabels = [newLabels {sprintf('%s (%.1f%%)', labels{i}, xPercent(i))}];     
end

% Plot the pie chart
pie(counts, newLabels);

%% 
% Plot the histogram of some columns to show their distribution
finishing = MLdataset.attacking_finishing;
histogram(finishing);
title('Distribution of finishing')
xlabel('Values');
ylabel('Frequency');

sliding = MLdataset.defending_sliding_tackle;
standing = MLdataset.defending_standing_tackle;

% Plotting the histogram with different colors
histogram(sliding, 'FaceColor', 'blue', 'EdgeColor', 'black', 'BinWidth', 0.5, 'DisplayName', 'Sliding Tackle');
hold on; % To superimpose the second histogram on the first one
histogram(standing, 'FaceColor', 'red', 'EdgeColor', 'black', 'BinWidth', 0.5, 'DisplayName', 'StandingTackle');
hold off; % Release the hold on the plot

title('Distribution of Standing and Sliding tackle');
xlabel('Values');
ylabel('Frequency');
legend;  

%% Correlation matrix

% Calculating the correlation matrix

Heatmap = [MLdataset.attacking_finishing MLdataset.attacking_volleys MLdataset.defending_marking_awareness MLdataset.defending_sliding_tackle MLdataset.power_shot_power MLdataset.movement_acceleration MLdataset.movement_reactions MLdataset.movement_balance];

matrix = corrcoef(Heatmap);

%create the heatmap showing the correlation coefficients

h = heatmap(matrix);

% Add the labels

h.XData = {'Finishing', 'Volleys', 'Marking' 'Sliding Tackle', 'Shot Power', 'Acceleration', 'Reactions', 'Balance'};
h.YData = {'Finishing', 'Volleys', 'Marking' 'Sliding Tackle', 'Shot Power', 'Acceleration', 'Reactions', 'Balance'};
title('Correlation between player attributes');

% Set tick labels for each tick
h.XDisplayLabels = h.XData;
h.YDisplayLabels = h.YData;


colorbar;

%% Scatterplot of some skills with different hue for each position, to demonstrate potential clusters visually.

% Create a scatter plot with different colors for each hue value

% Separate the data by assigning each position to a factor
gk = (MLdataset.club_position == 'Goalkeeper');
att = (MLdataset.club_position == 'Attacker');
mid = (MLdataset.club_position == 'Midfielder');
def = (MLdataset.club_position == 'Defender');

%Compute the variables for each position 
gk_balance = MLdataset.movement_balance(gk);
att_balance = MLdataset.movement_balance(att);
mid_balance = MLdataset.movement_balance(mid);
def_balance = MLdataset.movement_balance(def);

gk_strength = MLdataset.power_strength(gk);
att_strength = MLdataset.power_strength(att);
mid_strength = MLdataset.power_strength(mid);
def_strength = MLdataset.power_strength(def);

% Plot all the variables by position one by one using 'hold on'
figure;
scatter(gk_balance, gk_strength, 'black', 'filled');
hold on;
scatter(att_balance, att_strength, 'red', 'filled');
hold on;
scatter(mid_balance, mid_strength, 'green', 'filled');
hold on;
scatter(def_balance, def_strength, 'blue', 'filled');
title('Plot of Strength and Balance by position');
legend('Goalkeeper', 'Attacker', 'Midfielder', 'Defender');
xlabel('Balance')
ylabel('Strength')
xticks(0:5:100); % display ticks on x axis from 0 to 100, 5 by 5
yticks(0:5:100); % display ticks on y axis from 0 to 100, 5 by 5


hold off;
% Data is messy and we don't really see any clusters, because Strength and
% balance are technically not specific to a position, therefore these 2
% factors should not be relevant in classifying our data.
%% Another scatter plot for Pace and finishing to isolate clusters better

%Compute the variables for each position 
gk_finishing = MLdataset.attacking_finishing(gk);
att_finishing = MLdataset.attacking_finishing(att);
mid_finishing = MLdataset.attacking_finishing(mid);
def_finishing = MLdataset.attacking_finishing(def);

gk_pace = MLdataset.movement_sprint_speed(gk);
att_pace = MLdataset.movement_sprint_speed(att);
mid_pace = MLdataset.movement_sprint_speed(mid);
def_pace = MLdataset.movement_sprint_speed(def);

% Plot all the variables by position one by one using 'hold on'
figure;
scatter(gk_finishing, gk_pace, 'black', 'filled');
hold on;
scatter(att_finishing, att_pace, 'red', 'filled');
hold on;
scatter(mid_finishing, mid_pace, 'green', 'filled');
hold on;
scatter(def_finishing, def_pace, 'blue', 'filled');
title('Plot of Finishing and Sprint speed by position');
legend('Goalkeeper', 'Attacker', 'Midfielder', 'Defender');
xlabel('Finishing')
ylabel('Sprint Speed')

xticks(0:5:100); % display ticks on x axis from 0 to 100, 5 by 5
yticks(0:5:100); % display ticks on y axis from 0 to 100, 5 by 5


hold off;
% All the positions besides goalkeepers seem to have a similar distribution
% of the pace, but finishing shows the prevalence of strikers in this area,
% compared to midfielders and defenders. 

%% A last scatter plot with highly specific and correlated variables (sliding and standing tackling)

%Compute the variables for each position 
gk_standing = MLdataset.defending_standing_tackle(gk);
att_standing = MLdataset.defending_standing_tackle(att);
mid_standing = MLdataset.defending_standing_tackle(mid);
def_standing = MLdataset.defending_standing_tackle(def);

gk_sliding = MLdataset.defending_sliding_tackle(gk);
att_sliding = MLdataset.defending_sliding_tackle(att);
mid_sliding = MLdataset.defending_sliding_tackle(mid);
def_sliding = MLdataset.defending_sliding_tackle(def);

% Plot all the variables by position one by one using 'hold on'
figure;
scatter(gk_standing, gk_sliding, 'black', 'filled');
hold on;
scatter(att_standing, att_sliding, 'red', 'filled');
hold on;
scatter(mid_standing, mid_sliding, 'green', 'filled');
hold on;
scatter(def_standing, def_sliding, 'blue', 'filled');
title('Plot of Standing and Sliding tackling by position');
legend('Goalkeeper', 'Attacker', 'Midfielder', 'Defender');
xlabel('Standing tackle')
ylabel('Sliding tackle')

xticks(0:2:100); % display ticks on x axis from 0 to 100, 5 by 5
yticks(0:2:100); % display ticks on y axis from 0 to 100, 5 by 5

%% Boxplot to show the various distribution by position and how useful this can be to predict the position

figure;
boxplot(MLdataset.defending_sliding_tackle, MLdataset.club_position);
xlabel('Position')
ylabel('Sliding Tackle')

%% 10-fold cross validation, Classification tree with all parameters

% Store the target variable Y and the features X

X = MLdataset(:,5:33);
Y = MLdataset.club_position;

% seed so that experiment can be reproduced
rng(1);

% 10-fold cross validation using cvpartition

cv = cvpartition(height(MLdataset), 'KFold', 10);

% Create a variable to store the model accuracy for each fold

acc = zeros(cv.NumTestSets, 1);

% Get variables to store true and predicted labels for our confusion matrix
TrueLabels = [];
PredictedLabels = [];

% Perform 10-fold cross-validation
for fold = 1:cv.NumTestSets
    % Get the indices for the training and testing sets for this fold
    traindata = training(cv, fold);
    testdata = test(cv, fold);

    % Create the decision tree model using the training data for this fold
    model = fitctree(X(traindata, :), Y(traindata));

    % Make predictions on the test set for this fold
    pred = predict(model, X(testdata, :));

    % Evaluate the accuracy for a given fold
    acc(fold) = sum(pred == Y(testdata)) / numel(pred);

    % Store the true and predicted labels for every fold
    TrueLabels = [TrueLabels; Y(testdata)];
    PredictedLabels = [PredictedLabels; pred];
end

% Display average accuracy across all folds
averageAccuracy = mean(acc);
disp(['Average Accuracy (10-fold cross-validation): ', num2str(averageAccuracy * 100), '%']);

% Compute the confusion matrix
confmat = confusionmat(TrueLabels, PredictedLabels);

% Plot the confusion matrix

disp('Confusion Matrix');
disp(confmat);

% Calculate precision, recall, and F1 score for each class
% 
classes = size(confmat, 1);
precision = zeros(classes, 1);
recall = zeros(classes, 1);
f1score = zeros(classes, 1);

for i = 1:classes
    % Precision = TP / (TP + FP)
    precision(i) = confmat(i,i) / sum(confmat(:,i)); 
    % Recall = TP / (TP + FN)
    recall(i) = confmat(i,i) / sum(confmat(i,:));    
    f1score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
end

% Display the results for each class
for i = 1:classes
    disp(['Class ', num2str(i), ':']);
    disp(['  Precision: ', num2str(precision(i) * 100), '%']);
    disp(['  Recall: ', num2str(recall(i) * 100), '%']);
    disp(['  F1 Score: ', num2str(f1score(i) * 100), '%']);
end

% Calculate macro-average precision, recall, and F1 score
avgprecision = mean(precision);
avgrecall = mean(recall);
avgf1score = mean(f1score);

% Display the macro-average results
disp(['Average Precision: ', num2str(avgprecision * 100), '%']);
disp(['Average Recall: ', num2str(avgrecall * 100), '%']);
disp(['Average F1 Score: ', num2str(avgf1score * 100), '%']);

%% Naive Bayes









