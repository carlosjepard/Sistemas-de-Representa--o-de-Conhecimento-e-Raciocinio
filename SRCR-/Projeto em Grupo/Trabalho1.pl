%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI/3


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).


%-----------------------------------------------------------------------------
% SICStus PROLOG: definicoes iniciais

:- op( 900, xfy,'::' ).
:- dynamic adjudicante/4.
:- dynamic adjudicatária/4.
:- dynamic contrato/9.
:- dynamic incNIF/1.
:- dynamic incMorada/1.
:- dynamic incValor/1.
:- dynamic incPrazo/1.
:- dynamic imprecisoCusto/3.
:- dynamic nuloInterditoVal/1.
% ----------------------------- CONHECIMENTO -------------------------------- %


% adjudicante: #IdAd, Nome, NIF, Morada ↝{𝕍,𝔽,𝔻}
adjudicante(1, Municipio de Braga, 506901173, 'Braga').
adjudicante(2, Teatro Circo de Braga, 500463964, 'Braga').
adjudicante(3, Universidade do Minho, 502011378, 'Braga').
adjudicante(4, Centro Hospitalar do Alto Ave, 508080827, 'Guimarães').
adjudicante(5, Tribunal Constitucional, 600014193, 'Lisboa').
adjudicante(7, Direção Geral da Saúde, 600037100, 'Lisboa').
adjudicante(8, Universidade do Porto,  501413197, 'Porto').
adjudicante(9, Instituto Nacional de Estatística, 502237490, 'Lisboa').
adjudicante(10, Municipio de Fafe, 506841561, 'Fafe').


% adjudicatária: #IdAda, Nome, NIF, Morada↝{𝕍,𝔽,𝔻}



%contrato:#IdAd, #IdAda, TipoDeContrato, TipoDeProcedimento, Descrição, Valor, Prazo, Local, Data↝{𝕍,𝔽,𝔻}



% ------------------------- CONHECIMENTO NEGATIVO ---------------------------- %

% nao pode ser adjudicante se for adjudicatária 




% ------------------------ CONHECIMENTO IMPERFEITO --------------------------- %

% --------- CONHECIMENTO INCERTO

% Adoção do pressuposto do domínio fechado -> adjudicante
-adjudicante(IdAd, Nome, NIF, Morada) :- nao(adjudicante(IdAd, Nome, NIF, Morada)),
                                         nao(excecao(adjudicante(IdAd, Nome, NIF, Morada))).


% Deu entrada uma Entidade adjudicante com nif desconhecido
adjudicante(14, Municipio de Bragança, incNIF1, 'Bragança').
excecao(adjudicante(IdAd, Nome, NIF, Morada)) :- adjudicante(IdAd, Nome, incNIF1, Morada).
incNIF(incNIF1).

% Deu entrada uma Entidade adjudicante com morada desconhecida
adjudicante(15, Instituto do Emprego e da Formação Profissional, I. P., 501442600, incMorada1).
excecao(adjudicante(IdAd, Nome, NIF, Morada)) :- adjudicante(IdAd, Nome, NIF, incMorada1).
incMorada(incMorada1).


% Adoção do pressuposto do domínio fechado -> adjudicatária
-adjudicatária(IdAda, Nome, NIF, Morada) :- nao(adjudicatária(IdAda, Nome, NIF, Morada)),
                                            nao(excecao(adjudicatária(IdAda, Nome, NIF, Morada))).

% Deu entrada uma Entidade adjudicatária com nif desconhecido
adjudicatária(14, Topgim Material Desportivo e Lazer, Lda., incNIF1, 'Sintra').
excecao(adjudicatária(IdAda, Nome, NIF, Morada)) :- adjudicatária(IdAda, Nome, incNIF1, Morada).
incNIF(incNIF1).

% Deu entrada uma Entidade adjudicatária com morada desconhecida
adjudicatária(15, Otis elevadores, Lda., 500069824, incMorada1).
excecao(adjudicatária(IdAd, Nome, NIF, Morada)) :- adjudicatária(IdAd, Nome, NIF, incMorada1).
incMorada(incMorada1).

% Adoção do pressuposto do dominio fechado -> contrato
-contrato(IdAd, IdAda, TipoDeContrato, TipoDeProcedimento, Descricao, Valor, Prazo, Local, Data) :- nao(contrato(IdAd, IdAda, TipoDeContrato, TipoDeProcedimento, Descricao, Valor, Prazo, Local, Data)),
                                                                                                    nao(excecao(contrato(IdAd, IdAda, TipoDeContrato, TipoDeProcedimento, Descricao, Valor, Prazo, Local, Data))).

% O contrato tem um valor desconhecido
contrato(1, 6, 'Aquisição de serviços', 'Consulta Prévia', 'Assessoria jurídica', incValor1, '300 dias', 'Braga',(11-02-2020)).
excecao(contrato(IdAd, IdAda, TipoDeContrato, TipoDeProcedimento, Descricao, Valor, Prazo, Local, Data)) :- contrato(IdAd, IdAda, TipoDeContrato, TipoDeProcedimento, Descricao, incValor1, Prazo, Local, Data)
incValor(incValor1).

% O contrato tem um prazo desconhecido
contrato(10, 3, 'Aquisição de serviços', 'Ajuste Direto Regime Geral', 'Assessoria jurídica', 13 599, incPrazo1, 'Fafe', (02-02-2020)).
excecao(contrato(IdAd, IdAda, TipoDeContrato, TipoDeProcedimento, Descricao, Valor, Prazo, Local, Data)) :- contrato(IdAd, IdAda, TipoDeContrato, TipoDeProcedimento, Descricao, Valor, incPrazo1, Local, Data)
incPrazo(incPrazo1).

% --------- CONHECIMENTO IMPRECISO

% O valor do contrato X encontra-se entre 5000 e 6000 euros
excecao(contrato(3, 9, 'Aquisição de serviços', 'Ajuste Direto Regime Geral', 'Assessoria jurídica', X, '500 dias', 'Braga', (21-01-2020))) :- X > 5000, X < 6000.
imprecisoCusto(3,9,(21-01-2020)).


% --------- CONHECIMENTO INTERDITO




% Por questões de confidencialidade não se pode saber:
%         - valor
nuloInterditoVal(nuloValor1).
excecao(contrato(IdAd, IdAda, TipoDeContrato, TipoDeProcedimento, Descricao, Valor, Prazo, Local, Data)) :- contrato(IdAd, IdAda, TipoDeContrato, TipoDeProcedimento, Descricao, nuloValor1, Prazo, Local, Data). % Não esquecer de adicionar invariante!
contrato(16, 16, 'Empreitadas de obras públicas', 'Ajuste Direto Regime Geral', 'Reposição do pavimento de valas da rede de água na EN 207-1, em Barrosas St.º Estêvão', nuloValor1, '20 dias', 'Lousada', (15-03-2020)).
+contrato(Id,Id2,TC,TP,D,V,P,L,DT) :: (findall( (Id,Id2,TC,TP,D,V,P,L,DT), (contrato(16, 16, 'Empreitadas de obras públicas', 'Ajuste Direto Regime Geral', 'Reposição do pavimento de valas da rede de água na EN 207-1, em Barrosas St.º Estêvão', Va, '20 dias', 'Lousada', (15-03-2020)),nao(nuloInterditoIda(Va))), S),
                            comprimento(S,N),
                            N==0).



% ------------------------- Construção do Caso Prático ---------------------- 
%
% Registar adjudicantes, adjudicatárias e contratos

% Invariante Estrutural: Não podem existir adjudicantes repetidos (com o mesmo ID).
+adjudicante( IdAd, _, _, _) :: ( integer(IdAd),
                               findall(IdAd, adjudicante(IdAd, Nome, NIF, Morada), S),
                               comprimento( S, N ), N == 1 ).

% Invariante Referencial: NIF valido
+adjudicante( _, _, NIF, _) :: ( integer(NIF),
                                 NIF >= 100000000, NIF <= 999999999).

% Invariante Estrutural: Não podem existir adjudicatárias repetidas (com o mesmo ID).
+adjudicatária( IdAda, _, _, _) :: ( integer(IdAda),
                               findall(IdAda, adjudicatária(IdAda, Nome, NIF, Morada), S),
                               comprimento( S, N ), N == 1 ).


% Invariante Referencial: NIF valido
+adjudicatária( _, _, NIF, _) :: ( integer(NIF),
                                 NIF >= 100000000), NIF <= 999999999).




% Invariante Referencial: Só se pode adicionar um contrato se o adjudicante e a adjudicatária existir.
+contrato(IdAd, IdAda, _, _, _, _, _, _, _) :: ( findall( IdAd, adjudicante(IdAd, Nome, NIF, Morada), L), comprimento(L,S), S == 1,
                                        findall( IdAda, adjudicatária(IdAda, Nome, NIF, Morada), X), comprimento(X,C), C == 1 )


% Invariante Referencial: Só se pode adicionar um contrato se o adjudicante e a adjudicatária existir.
%Nao sei como fazer para ver se é ajuste direto ou nao
%+contrato(_, _, _, TipoDeProcedimento, _, Valor, _, _, _) :: ( integer(Valor),
                                 								Valor <= 5000).


%
% ------------------------------------------------------------------------ %
%
% Remover adjudicantes, adjudicatárias e contratos


% Invariante Estrutural: Só se pode eliminar se existir o ID existir na Base de Conhecimento.
-adjudicante( IdAd, _, _, _) :: ( integer(IdAd),
                               findall(IdAd, adjudicante(IdAd, Nome, NIF, Morada), S),
                               comprimento( S, N ), N == 0 ).

% Invariante Referencial: Só se pode eliminar adjudicante se não existirem contratos com esta entidade.
-adjudicante( IdAd, _, _, _) :: ( findall( IdAd, contrato(IdAd, IdAda, TipoDeContrato, TipoDeProcedimento, Descricao, Valor, Prazo, Local, Data), L),
                                 comprimento( L, N),
                                 N == 0 ).

% Invariante Estrutural: Só se pode eliminar se o ID existir na Base de Conhecimento.
-adjudicatária( IdAda, _, _, _) :: ( integer(IdAda),
                               findall(IdAda, adjudicatária(IdAda, Nome, NIF, Morada), S),
                               comprimento( S, N ), N == 0 ).

% Invariante Referencial: Só se pode eliminar adjudicatárias se não existirem contratos com esta entidade.
-adjudicatária( IdAda, _, _, _) :: ( findall( IdAda, contrato(IdAd, IdAda, TipoDeContrato, TipoDeProcedimento, Descricao, Valor, Prazo, Local, Data), L),
                                 comprimento( L, N),
                                 N == 0 ).











% -------------------------- Predicados Auxiliares -------------------------- %

% Extensão do Predicado comprimento: ListaElem, Comp -> {V,F}
comprimento([],0).
comprimento([X|L], C) :- comprimento(L, N), C is 1+N.

% Extensão do predicado sum: X, R -> {V, F}, faz o somatório de uma lista.
sum([], 0).
sum([X|L], R) :- sum(L, R1), R is X + R1.

% Extensão do predicado apagaReps: L, R -> {V, F}
% Apaga diversos elementos repetidos numa lista.
apagaReps([], []).
apagaReps([H|T], [H|L]) :- apagaT(H, T, X),
                           apagaReps(X, L).

% Extensão do predicado apagaT: X, L, R -> {V, F}
% Apaga todas as ocorrências repetidas de um elemento numa lista.
apagaT(X, [], []).
apagaT(X,[X|L1],L2) :- apagaT(X,L1,L2).
apagaT(X,[Y|L1],[Y|L2]) :- apagaT(X,L1,L2).

% Extensão do predicado concatenar : L1,L2,R -> {V,F}
concatenar([],L,L).
concatenar([X|L1],L2,[X|L3]) :- concatenar(L1,L2,L3).

% Extensão do predicado concListList: LLs, L -> {V, F}
% Utilizando o predicado auxiliar concatenar, concatena listas dentro de uma lista.
concListList([], []).
concListList([H|T], L) :- concListList(T, L1),
                          concatenar(H, L1, L).

% insercao: T -> {V,F}
insercao(T) :- assert(T).
insercao(T) :- retract(T), !, fail.

% remocao: T -> {V,F}
remocao(T) :- retract(T).
remocao(T) :- assert(T), !, fail.

% teste: L -> {V,F}
teste( [] ).
teste( [I|Is] ) :- I, teste(Is).

% evolucao: T -> {V,F}
evolucao(T) :- findall(I,+T::I,Li),
		       insercao(T),
		       teste(Li).

% involucao: T -> {V,F}
involucao(T) :- T,
                findall(I,-T::I,Li),
                remocao(T),
                teste(Li).







% Extensao do meta-predicado nao: Questao -> {V,F}
nao( Questao ) :-
      Questao, !, fail.
nao( Questao ).
