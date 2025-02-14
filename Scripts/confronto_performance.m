% Numero di esperimenti per ogni configurazione
m = 1000;  % Ad esempio, 50 esperimenti per configurazione

% Variabili per memorizzare i tempi di esecuzione per ogni esperimento
tempiTagliaA = zeros(1, 1);
tempiTagliaB = zeros(1, 1);
tempiProbA = zeros(1, 1);
tempiProbB = zeros(1, 1);
erroreTagliaA = zeros(1, 1);
erroreTagliaB = zeros(1, 1);
erroreProbA = zeros(1, 1);
erroreProbB = zeros(1, 1);

% ===== Per taglia del reticolo =====
counter = 1;
N = 100;

for i = 10:10:N
    p = 0.6;
    matrix = rand(i) < p;
    
    % Ripeti l'esperimento m volte per ciascuna configurazione di dimensione
    tempiA = zeros(m, 1);
    tempiB = zeros(m, 1);
    
    for j = 1:m
        tic;
        A = HK(p, i, matrix);
        tempiA(j) = toc;
        
        tic;
        B = CercaCluster2(i, p, matrix);
        tempiB(j) = toc;
        
        % Confronto la correttezza
        if A.percolazioneTB ~= B.percolazioneTB || A.percolazioneLR ~= B.percolazioneLR
            error("Risultato non corretto");
        end
    end
    
    % Calcola la media e l'errore
    tempiTagliaA(counter) = mean(tempiA);
    tempiTagliaB(counter) = mean(tempiB);
    erroreTagliaA(counter) = std(tempiA) / sqrt(m);
    erroreTagliaB(counter) = std(tempiB) / sqrt(m);
    
    counter = counter + 1;
end

% ===== Per probabilità di colorazione fissata e variare della probabilità =====
counter = 1;
p_values = 0:0.1:1;
for i = 1:length(p_values)
    matrix = rand(100) < p_values(i);
    
    % Ripeti l'esperimento m volte per ciascuna probabilità
    tempiA = zeros(m, 1);
    tempiB = zeros(m, 1);
    
    for j = 1:m
        tic;
        A = HK(p_values(i), 100, matrix);
        tempiA(j) = toc;
        
        tic;
        B = CercaCluster2(100, p_values(i), matrix);
        tempiB(j) = toc;
        
        if A.percolazioneTB ~= B.percolazioneTB || A.percolazioneLR ~= B.percolazioneLR
            error("Risultato non corretto");
        end
    end
    
    % Calcola la media e l'errore
    tempiProbA(counter) = mean(tempiA);
    tempiProbB(counter) = mean(tempiB);
    erroreProbA(counter) = std(tempiA) / sqrt(m);
    erroreProbB(counter) = std(tempiB) / sqrt(m);
    
    counter = counter + 1;
end

% Primo grafico: dimensioni del reticolo
figure; % Crea una nuova finestra grafica
hold on;
xlabel("Dimensioni reticolo");
ylabel("Tempi di esecuzione");
title("Confronto delle performance sulla taglia del reticolo");
legend('Location', 'best');
grid on;
errorbar(10:10:N, tempiTagliaA, erroreTagliaA, "b", "DisplayName", "Algoritmo di Hoshen-Kopelman");
errorbar(10:10:N, tempiTagliaB, erroreTagliaB, "r", "DisplayName", "Algoritmo visto a lezione");
hold off;

% Secondo grafico: probabilità di colorazione
figure; % Crea una nuova finestra grafica
hold on;
xlabel("Probabilità di colorazione");
ylabel("Tempi di esecuzione");
title("Confronto delle performance sulla probabilità di colorazione");
legend('Location', 'best');
grid on;
errorbar(p_values, tempiProbA, erroreProbA, "b", "DisplayName", "Algoritmo di Hoshen-Kopelman");
errorbar(p_values, tempiProbB, erroreProbB, "r", "DisplayName", "Algoritmo visto a lezione");
hold off;