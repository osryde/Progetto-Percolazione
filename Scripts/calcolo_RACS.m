p = [0.591:0.0001:0.6]; % Probabilità di colorazione
LL = [100]; % Dimensioni del reticolo
m = 1000;
p_max = zeros(length(LL),1);% Calcolo soglia percolazione

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
        RACS = zeros(m,1);
        
        for j= 1:m
            
            A = HK(pp, L); % Genera il reticolo usando l'algoritmo HK
            ncluster = max(unique(max(A.label)));
            
            if ncluster == 0
                break;
            end

            clusters = zeros(ncluster,1);
            
            
            % Elementi per ogni label sommati al vero cluster di
            % appartenenza
            for k = 1:ncluster
                clusters(A.labelOfLabel(k)) = clusters(A.labelOfLabel(k)) + length(find(A.label == k));
            end
    
            % Rimuovo i cluster vuoti
            clusters = clusters(clusters ~= 0);
            s_max = max(unique(clusters)); % Dimensione del cluster massimo
            
            % Calcoli
            clusters_no_max = unique(clusters(clusters ~= s_max));
            numeratore = 0;

            % Calcolo la sommatoria della formula al numeratore. Sommo gli
            % elementi di dimensione uguale
            for k= 1:length(unique(clusters_no_max))
                numeratore = clusters_no_max(k) * (clusters_no_max(k) * length(find(clusters == clusters_no_max(k))));
            end

            RACS(j) = numeratore / sum(clusters);
        end
       
        data(i) = mean(RACS);
        errors(i) = std(RACS)/sqrt(m);
    end

    % Calcolo soglia
    p_max(idx) = unique(p(find(data == max(data))));

    errorbar(p, data,errors, "Color", colors(idx,:), "DisplayName", "Dimensione " + L);
end
soglia = mean(p_max);
erroreSoglia = std(p_max)/sqrt(length(LL));

% Aggiungi etichette agli assi e la legenda
xlabel('Probabilità di colorazione');
ylabel('Media dei siti colorati senza il cluster massimo');
legend('show');
grid on;

