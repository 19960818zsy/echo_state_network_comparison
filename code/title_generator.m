function title = title_generator(parameters)
type_of_network = "";
if parameters.kappa == -1
   type_of_network = strcat(type_of_network, "random network"); 
else
   type_of_network = strcat(type_of_network, "lattice network");
end
title = strcat(func2str(parameters.function), ", ", type_of_network);
end