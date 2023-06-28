%e)

ta_slot_assignment([],[],_).

ta_slot_assignment([ta(Name,Slot)|T], [ta(Name,Slot1)|RemTAs1], Name):-
    Slot > 0,
    Slot1 is Slot-1,
    ta_slot_assignment(T, RemTAs1, Name).

ta_slot_assignment([ta(X,Slot)|T], [ta(X,Slot)|RemTAs1], Name):-
    X \= Name,
    ta_slot_assignment(T, RemTAs1, Name).

%d)

slot_assignment(0, TAs, TAs, []).

slot_assignment(LabsNum, [ta(NameH,SlotH)|TA_T], RemTAs, Assignment):-

    LabsNum > 0,
    LabsNum1 is LabsNum-1,
    
    ta_slot_assignment([ta(NameH,SlotH)|TA_T], [RemTAs1_H|RemTAs1_T], NameH),
    slot_assignment(LabsNum1, RemTAs1_T, RemTAs2, Assignment1),

    RemTAs = [RemTAs1_H|RemTAs2],
    Assignment = [NameH|Assignment1].

slot_assignment(LabsNum, [TA_H|TA_T], RemTAs, Assignment):-

    LabsNum > 0,
    slot_assignment(LabsNum, TA_T, RemTAs2, Assignment),

    RemTAs = [TA_H|RemTAs2].

%c)

max_slots_per_day([],_).
max_slots_per_day([[],[],[],[],[]],_).
max_slots_per_day(DaySched,Max):-
    flatten(DaySched, [H|T]),
    max_slots_helper([H|T], H, Count),
    Count =< Max,
    max_slots_per_day(T, Max).

max_slots_helper([],_,0).

max_slots_helper([X|T], X, Count):-
    max_slots_helper(T, X, Count1),
    Count is Count1 + 1.

max_slots_helper([H|T], X, Count):-
    H\=X,
    max_slots_helper(T, X, Count).

%b)

day_schedule([],RemTAs,RemTAs,[]).

day_schedule([H|T], TAs, RemTAs, Assignment):-

    slot_assignment(H, TAs, RemTAs1, Assignment1),
    day_schedule(T, RemTAs1, RemTAs, Assignment2),

    Assignment = [Assignment1|Assignment2].

%a)

week_schedule([],_,_,[]).

week_schedule([H|T], TAs, DayMax, WeekSched):-

    day_schedule(H, TAs, RemTAs, DaySched),
    max_slots_per_day(DaySched, DayMax),
    week_schedule(T, RemTAs, DayMax, WeekSched1),
    WeekSched = [DaySched|WeekSched1].    

