function normD = normalize_data(data)
normD = (data - mean(data)) ./ std(data);
end