function matrix = HK(p, L, mat)
% Algoritmo di Hoshen-Kopelman per la ricerca di Cluster in un reticolo
% quadrato bidimensionale
%
% input:
%       L: Lunghezza lato matrice
%       p: probabilità di colorazione
%
% output:
%       matrix.p: probabilità di avere un sito colorato
%       matrix.matrice: matrice dei siti colorati
%       matrix.label: matrice delle etichette dei cluster trovati
%       matrix.labelOfLabel: vettore delle etichette che lega i cluster tra
%                            loro
%       matrix.percolazioneTB: valore di esistenza di percolazione partendo
%       dal bordo superiore al bordo inferiore       
%       matrix.percolazioneLR: valore di esistenza di percolazione partendo
%       dal bordo sinistro al bordo destro

matrix.p = p;

% Inizializzazione matrice
if nargin < 3
    matrix.matrice = rand(L) < p;
else
    matrix.matrice = mat;
end

% Etichette
matrix.label = zeros(L);
matrix.labelOfLabel = 1:L*L; % Ogni entrata identifica il cluster radice di un cluster

% Percolazione
matrix.percolazioneLR = 0;
matrix.percolazioneTB = 0;

% Array contenente i siti colorati ordinati per colonna
valid = find(matrix.matrice);

% Numero cluster
cluster = 1;

for i = 1:length(valid)
    sito = valid(i);

    % Elemento sinistro
    if(sito <= L)
        left = 0;
    else
        left = matrix.label(sito - L);
    end
    

    % Elemento superiore
    if(mod(sito, L) == 1)
        top = 0;
    else
        top = matrix.label(sito - 1);
    end

    % Caso 1
    if(left == 0 && top == 0)
        matrix.label(sito) = cluster;
        cluster = cluster + 1;

    % Caso 2
    elseif((left == 0 && top ~= 0) || (left ~= 0 && top == 0) || (left == top))
        if left > top
            matrix.label(sito) = Find(left);
        else
            matrix.label(sito) = Find(top);
        end

    % Caso 3
    elseif(left ~= top && left ~= 0 && top ~= 0)
        Union(left,top)
        matrix.label(sito) = Find(left);
    end
   
end

% ===== Percolazione =====
% Identifico il cluster root di appartenenza dei cluster sui lati.
% Poi confronto su quelli.

left = unique(matrix.label(1:L));
left = left(left > 0);
realLeft = zeros(length(left), 1);

for i = 1:length(left)
    realLeft(i) = Find(left(i));
end

realLeft = unique(realLeft);

right = unique(matrix.label(L*(L-1) + 1:L*L));
right = right(right > 0);
realRight = zeros(length(right), 1);

for i = 1:length(right)
    realRight(i) = Find(right(i));
end

realRight = unique(realRight);

if (~isempty(intersect(realLeft, realRight)))
    matrix.percolazioneLR = 1;
end

top = unique(matrix.label(1:L:L*(L-1) + 1));
top = top(top > 0);
realTop = zeros(length(top), 1);

for i = 1:length(top)
    realTop(i) = Find(top(i));
end

realTop = unique(realTop);

bottom = unique(matrix.label(L:L:L*L));
bottom = bottom(bottom > 0);
realBottom = zeros(length(bottom), 1);

for i = 1:length(bottom)
    realBottom(i) = Find(bottom(i));
end

realBottom = unique(realBottom);

if (~isempty(intersect(realTop, realBottom)))
    matrix.percolazioneTB = 1;
end

% ===== Funzioni annidate ======
function Union(left, top)
    rootLeft = Find(left);
    rootTop = Find(top);
   
    if rootLeft > rootTop
        matrix.labelOfLabel(rootLeft) = rootTop; % Unisce left a top
    else
        matrix.labelOfLabel(rootTop) = rootLeft; % Unisce top a left
    end
end

function out = Find(x)
    out = x;
    
    % Trovo la radice
    while matrix.labelOfLabel(out) ~= out
        out = matrix.labelOfLabel(out);
    end

    % Aggiorno tutto il percorso al valore minimo
    while matrix.labelOfLabel(x) ~= x
        tmp = matrix.labelOfLabel(x);
        matrix.labelOfLabel(x) = out;
        x = tmp;
    end

end

end


