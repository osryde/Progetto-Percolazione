%p = [0:0.1:0.4 0.45:0.05:0.65 0.7:0.1:1]; % Probabilità di colorazione
p = [0:0.01:1];
LL = [10 20 30]; % Dimensioni del reticolo
m = 1000;

% Mappa dei colori
colors = lines(length(LL)); % Genera colori distinti per ogni curva

figure;
hold on;

for idx = 1:length(LL)
    L = LL(idx);
    data = zeros(length(p),1);
    errors = zeros(length(p),1);

    for i = 1:length(p)
        pp = p(i);
        P3 = zeros(m,1);

        for j= 1:m
            
            A = HK(pp, L); % Genera il reticolo usando l'algoritmo HK
            ncluster = max(unique(max(A.label)));
            
            if ncluster == 0
                break;
            end

            clusters = zeros(ncluster,1);
            
           
            % Elementi per ogni label
            for k = 1:ncluster
                clusters(A.labelOfLabel(k)) = clusters(A.labelOfLabel(k)) + length(find(A.label == k));
            end
    
            % Rimuovo i cluster vuoti
            clusters = clusters(clusters ~= 0);
            s_max = max(unique(clusters)); % Dimensione del cluster massimo
     
            % Calcoli
            P3(j) = s_max / sum(clusters);
        end
        data(i) = mean(P3);
        errors(i) = std(P3)/sqrt(m);
    end
    errorbar(p, data, errors, "Color", colors(idx,:), "DisplayName", "Dimensione " + L);
end

% Aggiungi etichette agli assi e la legenda
xlabel('Probabilità di colorazione');
ylabel('Frazione della dimensione del cluster massimo rispetto ai siti colorati effettivi');
legend('show');
grid on;

