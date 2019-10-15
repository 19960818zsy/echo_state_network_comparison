function data_splits = split_into_folds(target, fold_no)
data_length = length(target);
data_splits = [];
last_start = 1;
for k = 1:data_length
    if mod(k, round(data_length/fold_no)) == 0
        split = target(last_start:k);
        data_splits = [data_splits; cell(1,1)];
        data_splits{end} = split;
        last_start = k+1;
        if data_length - last_start < round(data_length/fold_no)
            split = target(last_start:data_length);
            data_splits = [data_splits; cell(1,1)];
            data_splits{end} = split;
            break;
        end
    end
end
end