function X = neuron_plots(V,b,u,x,i,c, length_to_plot, start_at)
figure;
hold on
for ii = start_at:0.1:start_at+0.9
    subplot(2, 5, (ii-start_at)*10 + 1);
    W = esn_setup_oscillators(10, 1, ii);
    X = esn(W,V,b,u,x,i,c);
    hold on
    for jj = 1:length(X(:,1))
        plot(X(jj,1:length_to_plot))
    end
    hold off
    xlabel("t")
    ylabel("Values of neurons")
    title(strcat("a = ", num2str(ii)));
end
hold off
end