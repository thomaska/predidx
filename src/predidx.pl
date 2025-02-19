/* Indexed Predicates                                                      */
/*                                                                         */
/* Copyright (C) 2021 Alexander Diemand                                    */
/*                                                                         */
/*   This program is free software: you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as published by  */
/*   the Free Software Foundation, either version 3 of the License, or     */
/*   (at your option) any later version.                                   */
/*                                                                         */
/*   This program is distributed in the hope that it will be useful,       */
/*   but WITHOUT ANY WARRANTY; without even the implied warranty of        */
/*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         */
/*   GNU General Public License for more details.                          */
/*                                                                         */
/*   You should have received a copy of the GNU General Public License     */
/*   along with this program.  If not, see <http://www.gnu.org/licenses/>. */
/*-------------------------------------------------------------------------*/

:- module(predidx, [
        tbl_create/3,
        tbl_has/2, tbl_has/3,
        tbl_find/4,
        tbl_get/3,
        tbl_set/3,
        tbl_unset/2,

        idx_create32/2,
        idx_add32/4,
        idx_find32/5,
        idx_destroy32/1,
        idx_create64/2,
        idx_add64/4,
        idx_find64/5,
        idx_destroy64/1
    ]).

:- use_foreign_library(sbcl('predidx')).


% tbl_create(+Atom, +List, -Number)
% create a table accessible by its name, pass in
% a list of options: 
%    max_rows(N)     ; maximum number of rows
%    realloc_rows(N) ; number of rows allocated at once
%    structure([S])  ; where S is one of
%       char         ; a signed integer, 8 bit width
%       int32        ; a signed integer, 32 bit width
%       int64        ; a signed integer, 64 bit width
%       uchar        ; an unsigned integer, 8 bit width
%       uint32       ; an unsigned integer, 32 bit width
%       uint64       ; an unsigned integer, 64 bit width
%       double       ; a double floating point number
%       atom         ; a Prolog atom
% (implicitly, a structure includes a flag whether the data point is valid or not)
tbl_create(TblName, Options, TblId) :-
    atom(TblName), nonvar(Options),
    var(TblId),
    % access option or assume default
    (once(member(max_rows(MaxRows), Options))
      ; MaxRows = 1000),
    (once(member(realloc_rows(AllocRows), Options))
      ; AllocRows = 33),
    (once(member(structure(S), Options))
      ; S = []),
    pl_tbl_create(TblName, MaxRows, AllocRows, S, TblId).

% tbl_has(+Number, +Number)
% check if table has index
tbl_has(TblId, Idx) :-
    integer(TblId), integer(Idx),
    pl_tbl_has_idx(TblId, Idx).

% tbl_has(+Number, -Number)
% (nondeterministic) iterate through indezes
tbl_has(TblId, Idx) :-
    integer(TblId), var(Idx),
    pl_tbl_next_idx(TblId, Idx).

% tbl_find(+Number, +Number, +Term, -Number)
% (nondeterministic) iterate through indezes
% matching equality criterium on field (0 indexed)
tbl_find(TblId, NField, Eq, Idx) :-
    integer(TblId), integer(NField), nonvar(Eq), var(Idx),
    pl_tbl_find_idx(TblId, NField, Eq, Idx).

% tbl_has(+Number, -Number, -List)
% (nondeterministic) iterate through indezes and values
tbl_has(TblId, Idx, Values) :-
    integer(TblId), var(Idx), var(Values),
    pl_tbl_next_idx(TblId, Idx),
    pl_tbl_get_idx_value(TblId, Idx, Values).

% tbl_set(+Number, +Number, +List)
% set value at index
tbl_set(TblId, Idx, Values) :-
    integer(TblId), nonvar(Idx), nonvar(Values),
    pl_tbl_set_idx_value(TblId, Idx, Values).

% tbl_get(+Number, +Number, -List)
% get value at index
tbl_get(TblId, Idx, Values) :-
    integer(TblId), nonvar(Idx), var(Values),
    pl_tbl_get_idx_value(TblId, Idx, Values).

% tbl_unset(+Number, +Number)
% invalidate value at index
tbl_unset(TblId, Idx) :-
    integer(TblId), nonvar(Idx),
    pl_tbl_invalidate_idx(TblId, Idx).

% tbl_info(+Number, -List)
% return a list of descriptors about the indexed predicate
tbl_info(TblId, Desc) :-
    integer(TblId), var(Desc),
    pl_tbl_info(TblId, Desc).

%
%  index
%

idx_create32(Dlen, Xid) :-
    integer(Dlen), var(Xid),
    pl_idx_create32(Dlen, Xid).

idx_add32(Xid, Key, Dlen, Value) :-
    nonvar(Xid), integer(Key), integer(Dlen), nonvar(Value),
    pl_idx_add32(Xid, Key, Dlen, Value).

idx_find32(Xid, Key, Dlen, Count, Results) :-
    nonvar(Xid), integer(Key), integer(Dlen), var(Count), var(Results),
    pl_idx_find32(Xid, Key, Dlen, Count, Results).

idx_destroy32(Xid) :-
    nonvar(Xid), pl_idx_destroy32(Xid).

idx_create64(Dlen, Xid) :-
    integer(Dlen), var(Xid),
    pl_idx_create64(Dlen, Xid).

idx_add64(Xid, Key, Dlen, Value) :-
    nonvar(Xid), integer(Key), integer(Dlen), nonvar(Value),
    pl_idx_add64(Xid, Key, Dlen, Value).

idx_find64(Xid, Key, Dlen, Count, Results) :-
    nonvar(Xid), integer(Key), integer(Dlen), var(Count), var(Results),
    pl_idx_find64(Xid, Key, Dlen, Count, Results).

idx_destroy64(Xid) :-
    nonvar(Xid), pl_idx_destroy64(Xid).

