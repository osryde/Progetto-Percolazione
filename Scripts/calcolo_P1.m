p = [0:0.01:1]; % Probabilità di colorazione
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
        P1 = zeros(m,1);

        for j= 1:m
            
            A = HK(pp, L); % Genera il reticolo usando l'algoritmo HK
            ncluster = max(unique(max(A.label))); % Valore del cluster più grande
            
            if ncluster == 0
                break;
            end

            clusters = zeros(ncluster,1);
    
            % Elementi nel cluster root per ogni etichetta
            for k = 1:ncluster
                clusters(A.labelOfLabel(k)) = clusters(A.labelOfLabel(k)) + length(find(A.label == k));
            end
    
            % Rimuovo i cluster vuoti
            clusters = clusters(clusters ~= 0);
            s_max = max(unique(clusters)); % Dimensione del cluster massimo
     
            % Calcoli
            P1(j) = s_max / L^2;
        end
        data(i) = mean(P1);
        errors(i) = std(P1)/sqrt(m);
    end
    errorbar(p, data, errors, "Color", colors(idx,:), "DisplayName", "Dimensione " + L);
end

% Aggiungi etichette agli assi e la legenda
xlabel('Probabilità di colorazione');
ylabel('Frazione della dimensione del cluster massimo');
legend('show');
grid on;

