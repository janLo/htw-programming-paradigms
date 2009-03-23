% Einfacher Turingprototyp

% Element auf das Band legen
myPush(List, Elem, Result) :- Result = [Elem|List].

% Element vom Band holen
myPop([Elem|Result], Elem, Result).
myPop([], Elem, Result) :- bl(X), Elem = X, Result = '[]'.

% Vorheriges Bandelement
myPrev(PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- 
    myPush(NListOld, ElemOld, NListNew), myPop(PListOld, ElemNew, PListNew).

% Naestes Bandelement
myNext(PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- 
    myPush(PListOld, ElemOld, PListNew), myPop(NListOld, ElemNew, NListNew).

% Bewegung des Bandes
myMove( r(n), PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- 
    PListNew = PListOld, NListNew = NListOld, ElemNew = ElemOld.
myMove( r(r), PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- 
    myPrev(PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew).
myMove( r(l), PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- 
    myNext(PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew).

replaceNonInput([X|Y],Z) :- e(X), replaceNonInput(Y,M), Z = [X|M],!.
replaceNonInput([X|Y],Z) :- not(e(X)), replaceNonInput(Y,M), Z = [' '|M],!.
replaceNonInput([],[]).

% Iterative Ausgabe der bandinhalte
myPrintIter([],    [],    '%%%')  :- !. 
myPrintIter([],    [X|Y], '%%%')  :- 
    write(', '), write(X), myPrintIter([], Y, '%%%'),!.
myPrintIter([],    NList,  Elem)  :- 
    write('['), write(Elem), write(']'), myPrintIter([], NList, '%%%'),!.
myPrintIter([X|Y], NList,  Elem)  :- 
    write(X), write(', '), myPrintIter(Y, NList, Elem),!.

% Ausgabe eines Bandes
myPrint(PList, NList,  Elem) :- 
    bl(X), write('..., '), write(X), write(' , '), write(X), write(', '), 
    reverse(PList,PList1),
    myPrintIter(PList1, NList, Elem), 
    write(', '), write(X), write(', '), write(X), write(', ...').
myPrint2(PList, NList,  Elem) :- 
    replaceNonInput(PList, P), 
    replaceNonInput([Elem|NList], [Z|N]), 
    reverse(P,P1),
    write('['),
    myPrintIter(P1,N,Z),
    write(']').

% Ausgabe der momentanen Bewegungsrichtung.
myPrintDir(r(n)) :- write('Nicht ').
myPrintDir(r(l)) :- write('Links ').
myPrintDir(r(r)) :- write('Rechts').

% Ausgabe des Fortschrittes der Turingmaschine
myPrintProgress(PList, NewPList, NList, NewNList,  Elem, NewElem, NewElem2, Zst, NewZst, r(Dir),N)  :- 
    write('Schritt '),write(N), write(':'),nl,
    write('    Momentaner Zustand: '), write(Zst), 
    write('; Momentanes Band:'),nl,
    write('      '),myPrint(PList, NList,  Elem),nl,
    write('    Gelesen: '), write(Elem),
    write('; Schreibe: '), write(NewElem),nl,
    write('    Bewege: '), myPrintDir(r(Dir)),
    write('; Folgezustand: '), write(NewZst),nl,
    write('    Resultierendes Band: '), nl, 
    write('      '),myPrint(NewPList, NewNList,  NewElem2),nl,
    write('fortsetzen mit [Enter] '),
    get_byte(O),!.

% Vollziehen der Zustandsuebergaenge der Turingmaschine 
run(PList, NList, Elem, z(Zst), N)  :- 
    ze(z(Zst)), 
    write('Fertig nach '), write(N), write(' Schritten:'), nl,
    write('    Endzustand: '), write(Zst), nl,
    write('    Elemente vor der aktuellen Position:  '), length(PList, J), write(J), nl,
    write('    Elemente nach der aktuellen Position: '), length(NList, I), write(I), nl,
    write('    Resultierendes Band:'),nl, 
    write('       '), myPrint(PList, NList,  Elem),nl, 
    write('    Ausgabeband (Band ohne Nichteingabesymbole):'),nl, 
    write('       '),myPrint2(PList, NList,  Elem),nl. 
run(PList, NList, Elem, z(Zst), N)  :- 
    b(Elem), 
    zu(z(Zst), Elem, NewElem, r(Dir), z(NewZst)), 
    myMove(r(Dir), PList, NewPList, NList, NewNList, NewElem, NewElem2),
    M is N+1,
    myPrintProgress(PList, NewPList, NList, NewNList, Elem, NewElem, NewElem2,Zst,NewZst, r(Dir), M),nl,
    run(NewPList, NewNList, NewElem2, z(NewZst), M),!. 

% prepareBand2 bringt die als Startband angegebene Liste in die Form [vorgaengerliste], aktuelles 
% Element, [Nachfolgerliste]. Als Aktuelles Element wird das Element an der als Startposition
% angegebenen Stelle gesetzt
prepareBand2(PList, NewPList, NList, NewNList, Elem, NewElem, N) :- 
    N > 0,
    myMove(r(l), PList, NewPListTmp, NList, NewNListTmp, Elem, NewElemTmp), 
    K is N - 1, 
    prepareBand2(NewPListTmp, NewPList, NewNListTmp, NewNList, NewElemTmp, NewElem, K).
prepareBand2(PList, NewPList, NList, NewNList, Elem, NewElem, 0) :- 
    NewPList = PList, NewNList = NList, NewElem = Elem,!.

% prepareBand ist eine Holfsklausel zum Aufruf von prepareBand2.
prepareBand(APos, [Z|ABand], PList,NList,Elem) :- 
    prepareBand2([], PList, ABand, NList, Z, Elem, APos).
prepareBand(_, [], PList,NList,Elem) :- 
    PList = [], NList = [], bl(Elem),!.

% Starten der Turingmaschine.
start :- ap(X),za(Y), ab(Z), 
         prepareBand(X,Z,PList,NList,Elem),
	 run(PList,NList,Elem, Y,0),!.

