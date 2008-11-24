myPush(List, Elem, Result) :- Result = [Elem|List].

myPop([Elem|Result], Elem, Result).
myPop([], Elem, Result) :- Elem = '%%', Result = '[]'.

myPrev(PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- myPush(NListOld, ElemOld, NListNew), myPop(PListOld, ElemNew, PListNew).
myNext(PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- myPush(PListOld, ElemOld, PListNew), myPop(NListOld, ElemNew, NListNew).

myMove( 0, PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- PListNew = PListOld, NListNew = NListOld, ElemNew = ElemOld.
myMove(-1, PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- myPrev(PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew).
myMove( 1, PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew) :- myNext(PListOld, PListNew, NListOld, NListNew, ElemOld, ElemNew).

myPrintIter([],    [],    '%%%')  :- !. 
myPrintIter([],    [X|Y], '%%%')  :- write(', '), write(X), myPrintIter([], Y, '%%%'),!.
myPrintIter([],    NList,  Elem)  :- write('['), write(Elem), write(']'), myPrintIter([], NList, '%%%'),!.
myPrintIter([X|Y], NList,  Elem)  :- write(X), write(', '), myPrintIter(Y, NList, Elem),!.

myPrint(PList, NList,  Elem) :- write('..., %% ,%%, '), myPrintIter(PList, NList, Elem), write(', %% ,%%, ...').

myPrintDir(0)  :- write('Nicht ').
myPrintDir(1)  :- write('Links ').
myPrintDir(-1) :- write('Rechts').

myPrintProgress(PList, NList,  Elem, Zst, Dir) :- write('Zustand: '), write(Zst), write('; Bewege: '), myPrintDir(Dir), write('; Band: '), myPrint(PList, NList,  Elem).

run(PList, NList, Elem, -1)  :- write('Resultierendes Band:'),nl, myPrint(PList, NList,  Elem). 
run(PList, NList, Elem, Zst) :- zu(Zst, Elem, NewElem, Dir, NewZst), myMove(Dir, PList, NewPList, NList, NewNList, NewElem, NewElem2), myPrintProgress(PList, NList,  Elem, Zst, Dir),nl,run(NewPList, NewNList, NewElem2, NewZst),!. 

test :- run([],[],'%%', 0).

% zu(zustd, gelesen, schreiben, bewegen, nextzust).
% % ist blank
% -1 ist ende
% 0 ist start
% bewegen: 0->stehen, 1->next, -1->prev

zu(0,'%%',  '1',  1, 1).
zu(1,'%%',  '1',  1, 2).
zu(2,'%%',  '1',  0, 3).
zu(3, '1',  '1', -1, 3).
zu(3,'%%', '%%',  1,-1).
