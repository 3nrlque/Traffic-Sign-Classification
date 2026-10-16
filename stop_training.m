function stop = stop_training(info, lossThreshold)

% Retrieve the current training loss
trainingLoss = info.TrainingLoss;

% Stop training when the training loss falls below the specified threshold
stop = trainingLoss < lossThreshold;

end
