% r(l|r|n) bewegungsrichtung
r(l).
r(r).
r(n).

% b(zeichen) .. Eingabealphabet
e('1').
e('0').

%bl(zeichen) .. "Blank"
bl('%').

%b(zeichen) .. bandalphabet
b(X) :- e(X).
b(X) :- bl(X).

% z(zeichen) .. Zustand
z(0).
z(1).
z(2).
z(3).
z(4).

% ze(zustand) .. Endzustand
ze(z(4)).

% za(Zustand) .. Startzustand
za(z(0)).

% zu(zustd, gelesen, schreiben, bewegen, nextzust).
% % ist blank
% -1 ist ende
% 0 ist start
% bewegen: 0->stehen, 1->next, -1->prev
zu(z(0),'%',  '1',  r(l), z(1)).
zu(z(1),'%',  '1',  r(l), z(2)).
zu(z(2),'%',  '1',  r(n), z(3)).
zu(z(3),'1', '1',  r(r), z(3)).
zu(z(3),'%', '%',  r(l), z(4)).

%ab(Liste) .. Anfangsband
ab(['%','%','%','%','%','%']).
%ap(Zahl) .. Anfangsposition auf Anfangsband
ap(3).
