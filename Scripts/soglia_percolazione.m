p = [0:0.01:1]; % Probabilità di colorazione
m = 1000; % Numero di misurazioni
Pperc = zeros(length(p), 1); % Preallocazione
Perr = zeros(length(p), 1); % Preallocazione
LL = [10 20 30]; % Lunghezze del reticolo

% Mappa dei colori
colors = lines(length(LL)); % Genera colori distinti per ogni curva

figure;
hold on;

for idx = 1:length(LL)
    L = LL(idx); % Dimensione corrente del reticolo
    
    for i = 1:length(p)
        pp = p(i); % Probabilità di colorazione
        success = zeros(m,1);
        successTB = zeros(m,1);
        successLR = zeros(m,1);

        for j = 1:m
            A = HK(pp, L); % Esegui l'algoritmo
            success(j) = (A.percolazioneTB || A.percolazioneLR);
            successTB(j) = A.percolazioneTB;
            successLR(j) = A.percolazioneLR;
        end
        
        Pperc(i) = mean(success); % Calcola la probabilità di percolazione
        Perr(i) = std(success)/sqrt(m); % Preallocazione
        
        threshold = 0.1; % Tolleranza
        if abs(mean(successTB) - mean(successLR)) / max(mean(successTB), mean(successLR)) > threshold
            warning("LR e TB hanno probabilità diverse per taglia "+ LL(idx) + " e probabilità " + p(i));
        end
    end
    
    % Traccia la curva con il colore specifico
    errorbar(p, Pperc, Perr, 'Color', colors(idx, :), 'DisplayName', sprintf('Lunghezza %d', L));
    
end

% Aggiungi titoli e assi
title("Probabilità di percolazione");
xlabel("Probabilità di colorazione del sito");
ylabel("Probabilità di percolazione");
grid on;

% Legenda automatica basata sui 'DisplayName'
legend('Location', 'best');

hold off;