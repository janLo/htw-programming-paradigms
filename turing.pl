myPush(List, Elem, Result) :- Result = [Elem|List].

myPop([Elem|Result], Elem, Result).
myPop([], Elem, Result) :- bl(X), Elem = X, Result = '[]'.

myPrev(PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- myPush(NListOld, ElemOld, NListNew), myPop(PListOld, ElemNew, PListNew).
myNext(PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- myPush(PListOld, ElemOld, PListNew), myPop(NListOld, ElemNew, NListNew).

myMove( r(n), PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- PListNew = PListOld, NListNew = NListOld, ElemNew = ElemOld.
myMove( r(r), PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- myPrev(PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew).
myMove( r(l), PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- myNext(PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew).

myPrintIter([],    [],    '%%%')  :- !. 
myPrintIter([],    [X|Y], '%%%')  :- write(', '), write(X), myPrintIter([], Y, '%%%'),!.
myPrintIter([],    NList,  Elem)  :- write('['), write(Elem), write(']'), myPrintIter([], NList, '%%%'),!.
myPrintIter([X|Y], NList,  Elem)  :- write(X), write(', '), myPrintIter(Y, NList, Elem),!.

myPrint(PList, NList,  Elem) :- bl(X), write('..., '), write(X), write(' , '), write(X), write(', '), 
                                myPrintIter(PList, NList, Elem), 
				write(', '), write(X), write(', '), write(X), write(', ...').


myPrintDir(r(n)) :- write('Nicht ').
myPrintDir(r(l)) :- write('Links ').
myPrintDir(r(r)) :- write('Rechts').

myPrintProgress(PList, NewPList, NList, NewNList,  Elem, NewElem, Zst, NewZst, r(Dir),N)  :- 
                                                  write('Schritt '),write(N), write(':'),nl,
                                                  write('    Momentaner Zustand: '), write(Zst), 
                                                  write('; Momentanes Band:'),nl,
						  write('    '),myPrint(PList, NList,  Elem),nl,
                                                  write('    Gelesen: '), write(Elem),
						  write('; Schreibe: '), write(NewElem),
						  write('; Bewege: '), myPrintDir(r(Dir)),
						  write('; Folgezustand: '), write(NewZst),
						  write('; Resultierendes Band: '), nl, 
						  write('    '),myPrint(NewPList, NewNList,  NewElem),nl,
						  sleep(1).
						  

run(PList, NList, Elem, z(Zst), N)  :- ze(z(Zst)), write('Resultierendes Band:'),nl, myPrint(PList, NList,  Elem). 
run(PList, NList, Elem, z(Zst), N)  :- b(Elem), zu(z(Zst), Elem, NewElem, r(Dir), z(NewZst)), 
                                       myMove(r(Dir), PList, NewPList, NList, NewNList, NewElem, NewElem2),
	                               M is N+1,
				       myPrintProgress(PList, NewPList, NList, NewNList, Elem, NewElem2, Zst,NewZst, r(Dir), M),nl,
				       run(NewPList, NewNList, NewElem2, z(NewZst), M),!. 


prepareBand2(PList, NewPList, NList, NewNList, Elem, NewElem, N) :- N > 0,
                                                                   myMove(r(l), PList, NewPListTmp, NList, NewNListTmp, Elem, NewElemTmp), 
                                                                   K is N - 1, 
								   prepareBand2(NewPListTmp, NewPList, NewNListTmp, NewNList, NewElemTmp, NewElem, K).
prepareBand2(PList, NewPList, NList, NewNList, Elem, NewElem, 0) :- NewPList = PList, NewNList = NList, NewElem = Elem,!.

prepareBand(APos, [Z|ABand], PList,NList,Elem) :- prepareBand2([], PList, ABand, NList, Z, Elem, APos).
prepareBand(_, [], PList,NList,Elem) :- PList = [], NList = [], bl(Elem).

start :- ap(X),za(Y), ab(Z), 
         prepareBand(X,Z,PList,NList,Elem),
	 run(PList,NList,Elem, Y,0).

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
zu(z(3), '1', '1',  r(r), z(3)).
zu(z(3),'%', '%',  r(l), z(4)).

%ab(Liste) .. Anfangsband
ab(['%','%','%','%','%','%']).
%ap(Zahl) .. Anfangsposition auf Anfangsband
ap(3).
