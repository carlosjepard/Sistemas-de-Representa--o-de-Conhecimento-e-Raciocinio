%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCIONIO - MiEI/3
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Ficheiro que contém a base de conhecimento.
:- include('cidades.pl').

% SICStus PROLOG: Declaracoes iniciais
:- set_prolog_flag(toplevel_print_options, [quoted(true), portrayed(true), max_depth(0)]).
:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).







%nao informada

%---------------------calcular trajeto possivel-----------------------------------------------------------

%---bfs------
bfs(Origem, Destino, Final) :- bf3([Origem], Destino, [], Caminho), naoCaminho(Destino, Caminho, [], Final).

bf3([Destino|_], Destino, Visitados, [Destino|Visitados]).
bf3([Origem|Cauda], Destino, Visitados, Caminho) :- findall(Prox,
													   (ligadas(Origem, Prox),
											 		   \+ member(Prox, Visitados),
										   		 	   \+ member(Prox, Cauda)),
											     	   Seguintes),
													   sort(Seguintes, Ordenados),
												       append(Cauda, Ordenados, Proximo),
											 		   bf3(Proximo, Destino, [Origem|Visitados], Caminho).


%---dfs-----

dfs(Origem, Destino, Caminho) :- profundidade(Origem, Destino, [Origem], Caminho).
												

profundidade(Destino, Destino,H, D) :- inverteCaminho(H,D).
profundidade(Origem, Destino, His, C) :- ligadas(Origem, Prox),
            						  \+ member(Prox, His),
            						  profundidade(Prox, Destino,[Prox|His], C). 
            
 
	


%-----------------Selecionar apenas cidades, com uma determinada caraterística, para um determinado trajeto-------
%---bfs---

bfsCaracteristica(Origem, Destino, Caracteristica,Final) :- bfCaracteristicaAux([Origem], Destino, [], Caminho,Caracteristica), naoCaminho(Destino, Caminho, [], Final).

bfCaracteristicaAux([Destino|_], Destino, Visitados, [Destino|Visitados],Caracteristica).
bfCaracteristicaAux([Origem|Cauda], Destino, Visitados, Caminho,Caracteristica) :- findall(Prox,
													   (ligadas(Origem, Prox),
											 		   \+ member(Prox, Visitados),
										   		 	   \+ member(Prox, Cauda),
										   		 	   temCaracteristica(Prox,Caracteristica)),
											     	   Seguintes),
													   sort(Seguintes, Ordenados),
												       append(Cauda, Ordenados, Proximo),
											 		   bfCaracteristicaAux(Proximo, Destino, [Origem|Visitados], Caminho,Caracteristica).

%---dfs---

dfsCaracteristica(Origem, Destino, Caracteristica, Caminho) :- profundidadeCaracteristica(Origem, Destino, Caracteristica, [Origem], Caminho).
												

profundidadeCaracteristica(Destino, Destino, Caracteristica, H, D) :- inverteCaminho(H,D).
profundidadeCaracteristica(Origem, Destino, Caracteristica, His, C) :- ligadas(Origem, Prox),
            						  							       \+ member(Prox, His),
            						  								   temCaracteristica(Prox,Caracteristica),
            						                                   profundidadeCaracteristica(Prox, Destino, Caracteristica, [Prox|His], C). 
            


%--------------Escolher um percurso que passe apenas por cidades “minor”-----------

%---bfs---
bfsminor(Origem, Destino,Final) :- bfminorAux([Origem], Destino, [], Caminho), naoCaminho(Destino, Caminho, [], Final).

bfminorAux([Destino|_], Destino, Visitados, [Destino|Visitados]).
bfminorAux([Origem|Cauda], Destino, Visitados, Caminho) :- findall(Prox,
													   (ligadas(Origem, Prox),
											 		   \+ member(Prox, Visitados),
										   		 	   \+ member(Prox, Cauda),
										   		 	   temMinor(Prox)),
										   		 	   Seguintes),
													   sort(Seguintes, Ordenados),
												       append(Cauda, Ordenados, Proximo),
											 		   bfminorAux(Proximo, Destino, [Origem|Visitados], Caminho).

%---dfs---

dfsMinor(Origem, Destino, Caminho) :- profundidadeMinor(Origem, Destino, [Origem], Caminho).
												

profundidadeMinor(Destino, Destino, H, D) :- inverteCaminho(H,D).
profundidadeMinor(Origem, Destino, His, C) :- ligadas(Origem, Prox),
		     							      \+ member(Prox, His),
            						  		  temMinor(Prox),
           			                          profundidadeMinor(Prox, Destino, [Prox|His], C). 


%---------------Excluir uma ou mais caracteristicas de cidades para um percurso-------------


%---bfs---
bfsMaisCaracteristica(Origem, Destino, Caracteristica,Final) :- bfMaisCaracteristicaAux([Origem], Destino, [], Caminho,Caracteristica), naoCaminho(Destino, Caminho, [], Final).

bfMaisCaracteristicaAux([Destino|_], Destino, Visitados, [Destino|Visitados],Caracteristica).
bfMaisCaracteristicaAux([Origem|Cauda], Destino, Visitados, Caminho,Caracteristica) :- findall(Prox,
													   								   (ligadas(Origem, Prox),
											 		   								   \+ member(Prox, Visitados),
										   		 	   								   \+ member(Prox, Cauda),
										   		 	   								   \+ temMaisCaract(Prox,Caracteristica)),
											     	   								   Seguintes),
													   								   sort(Seguintes, Ordenados),
												       								   append(Cauda, Ordenados, Proximo),
											 		   								   bfMaisCaracteristicaAux(Proximo, Destino, [Origem|Visitados], Caminho,Caracteristica).

%---dfs---

dfsMaisCaracteristica(Origem, Destino, Caracteristica, Caminho) :- profundidadeMaisCaracteristica(Origem, Destino, Caracteristica, [Origem], Caminho).
												

profundidadeMaisCaracteristica(Destino, Destino, Caracteristica, H, D) :- inverteCaminho(H,D).
profundidadeMaisCaracteristica(Origem, Destino, Caracteristica, His, C) :- ligadas(Origem, Prox),
		     							      			      			   \+ member(Prox, His),
            						  		                  			   \+ temMaisCaract(Prox,Caracteristica),
           			                                          			   profundidadeMaisCaracteristica(Prox, Destino, Caracteristica, [Prox|His], C). 	



%-----------------------------Identificar num determinado percurso qual a cidade com o maior número de ligações---------------------------

% Predicado que devolve cidade com o maior numero de ligacoes
bfsNumeroLigacoes(Origem, Destino, S) :- bfs(Origem, Destino, Caminho), meteNRLigacoes(Caminho, S).

% Predicado que obtem a cidade com o maior numero de ligacoes
meteNRLigacoes(Lista, Final) :- getNumeroCidadesCaminho(Lista,[],S), maximo(S,Final).

% Obter lista com o número de ligacoes de cada Cidade.
getNumeroCidadesCaminho([], Lista, S) :- S = Lista.
getNumeroCidadesCaminho([Cid|T], Lista, S) :- getNumeroLigacoes(Cid,Ligacoes), getNumeroCidadesCaminho(T, [(Cid,Ligacoes)|Lista],S).


%----------------------Escolher uma ou mais cidades intermédias por onde o percurso deverá obrigatoriamente passar---------------------------

% Predicado que devolve o um caminho, consoante as cidades em que tem de passar
bfsCidades(Origem, Destino, [], Caminho) :- bfs(Origem, Destino, Lista), Caminho = Lista. 
bfsCidades(Origem, Destino, Cidades, Caminho) :- bfsCidadesAux(Origem, Destino, Cidades, [], Final), Caminho = [Origem|Final].
												 

bfsCidadesAux(Origem, Destino, [], Lista, Caminho) :- bfs(Origem, Destino, [H|T]), Lista1 = T, append(Lista,Lista1, Final), Caminho = Final.
bfsCidadesAux(Origem, Destino, [H|T], Lista, Caminho) :- bfs(Origem, H, [X|Y]),
														 Lista1 = Y,
			 										     append(Lista, Lista1, Aux),
													     bfsCidadesAux(H, Destino, T, Aux, Caminho).


%-------------------Escolher o menor percurso usando o critério do menor número de cidades percorridas----------------------

bfsMenosCidades(Origem, Destino, Caminho) :- bfsMenosCidadesAux([Origem], Destino, [], Caminho).

bfsMenosCidadesAux([Destino|_], Destino, Visitados, Caminho) :- Resultado = [Destino|Visitados], inverteCaminho(Resultado, Caminho).
bfsMenosCidadesAux([Origem|Cauda], Destino, Visitados, Caminho) :- findall(Prox,
																   (ligadas(Origem, Prox),
																   nao(member(Prox, Visitados)),
																   nao(member(Prox, Cauda))),
																   ListaLigadas),
																   calculaCidades(ListaLigadas, Destino, [], Ligada),
																   bfsMenosCidadesAux([Ligada|Cauda], Destino, [Origem|Visitados], Caminho).

% Predicado que calcula a Cidade com menor número de Cidades percorridas.
calculaCidades([X],Destino,Lista,Final) :- bfs(X, Destino, Caminho),
											length(Caminho, Y),
											R = [(X,Y)],
											append(R, Lista, Ligadas),
											ordenarC(Ligadas,Aux),
											firstPar(Aux, Par),
											Final = Par.

calculaCidades([H|T], Destino, Lista, S) :- bfs(H, Destino, Caminho),
											 length(Caminho, Y),
											 calculaCidades(T,Destino,[(H,Y)|Lista],S).




%informada

%--------------------------Escolher o percurso mais rápido usando o critério da distância--------------------


 fastestEstrela(Origem, Destino, Caminho/Custo) :-
    estima(Origem, Destino, Estima),
    aestrela([[Origem]/0/Estima], InvCaminho/Custo/_, Destino),
    inverteCaminho(InvCaminho, Caminho).

aestrela(Caminhos, Caminho, Destino) :-
    obtemFastest(Caminhos, Caminho, Destino),
    Caminho = [Destino|_]/_/_.

aestrela(Caminhos, SolucaoCaminho, Destino) :-
    obtemFastest(Caminhos, MelhorCaminho, Destino),
    eliminaNodo(MelhorCaminho, Caminhos, OutrosCaminhos),
    expande_aestrela(MelhorCaminho, ExpCaminhos, Destino),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
  aestrela(NovoCaminhos, SolucaoCaminho, Destino).

obtemFastest([Caminho], Caminho, Destino) :- !.

obtemFastest([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho, Destino) :-
    Custo1 + Est1 =< Custo2 + Est2, !,
    obtemFastest([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho, Destino).

obtemFastest([_|Caminhos], MelhorCaminho, Destino) :-
    obtemFastest(Caminhos, MelhorCaminho, Destino).

expande_aestrela(Caminho, ExpCaminhos, Destino) :-
    findall(NovoCaminho, ligadaEstrela(Caminho,NovoCaminho, Destino), ExpCaminhos).

ligadaEstrela([Origem|Caminho]/Custo/_, [ProxNodo,Origem|Caminho]/NovoCusto/Est, Destino) :-
    ligadas(Origem, ProxNodo),\+ member(ProxNodo, Caminho),
    estima(Origem, ProxNodo, PassoCusto),
    NovoCusto is Custo + PassoCusto,
    estima(ProxNodo,Destino, Est).


estima(Origem,Destino,Distancia) :- cidade(_,Origem,Latitude1,Longitude1,_,_,_),
                                                                  cidade(_,Destino,Latitude2,Longitude2,_,_,_),
                                                                  distanciaEuclidiana(Latitude1, Longitude1, Latitude2, Longitude2, Distancia).


%-----------------------------------------------------------Selecionar cidades minor -------------------------------------------

fastestEstrelaMinor(Origem, Destino, Caminho/Custo) :-
    estima(Origem, Destino, Estima),
    aestrelaMinor([[Origem]/0/Estima], InvCaminho/Custo/_, Destino),
    inverteCaminho(InvCaminho, Caminho).

aestrelaMinor(Caminhos, Caminho, Destino) :-
    obtemFastest(Caminhos, Caminho, Destino),
    Caminho = [Destino|_]/_/_.

aestrelaMinor(Caminhos, SolucaoCaminho, Destino) :-
    obtemFastest(Caminhos, MelhorCaminho, Destino),
    eliminaNodo(MelhorCaminho, Caminhos, OutrosCaminhos),
    expande_aestrelaMinor(MelhorCaminho, ExpCaminhos, Destino),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
  aestrelaMinor(NovoCaminhos, SolucaoCaminho, Destino).


expande_aestrelaMinor(Caminho, ExpCaminhos, Destino) :-
    findall(NovoCaminho, ligadaEstrelaMinor(Caminho,NovoCaminho, Destino), ExpCaminhos).

ligadaEstrelaMinor([Origem|Caminho]/Custo/_, [ProxNodo,Origem|Caminho]/NovoCusto/Est, Destino) :-
    ligadas(Origem, ProxNodo),
    \+ member(ProxNodo, Caminho),
    temMinor(ProxNodo),
    estima(Origem, ProxNodo, PassoCusto),
    NovoCusto is Custo + PassoCusto,
    estima(ProxNodo,Destino, Est).



%--------------predicados aux-------------------
nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).

ligadas(X,Y) :- ligacao(X,Y); ligacao(Y,X).

temCaracteristica(Cidade,Caract) :- cidade(_,Cidade,_,_,_,_,Caract).

temMinor(Cidade) :- cidade(_,Cidade,_,_,_,'minor',_).

temMaisCaract(Cidade, ListaC) :- getCaracteristicas(Cidade, Caracteristica), pertenceLista(Caracteristica, ListaC).

getCaracteristicas(Cidade, S) :- findall(Caracteristica, (cidade(_,Cidade,_,_,_,_,Caracteristica)), S).

pertenceLista([X],[]) :- !,fail.
pertenceLista([],X).
pertenceLista([X|XS],[Y|YS]) :- X==Y -> pertenceLista(XS,YS); pertenceLista([X|XS],YS).

distanciaEuclidiana(Latitude1, Longitude1, Latitude2, Longitude2, Distancia) :-
  P is 0.017453292519943295,
  A is (0.5 - cos((Latitude2 - Latitude1) * P) / 2 + cos(Latitude1 * P) * cos(Latitude2 * P) * (1 - cos((Longitude2 - Longitude1) * P)) / 2),
  Distancia is (12742 * asin(sqrt(A)) ).




eliminaNodo(E, [E|Xs], Xs).
eliminaNodo(E, [X|Xs], [X|Ys]) :- eliminaNodo(E, Xs, Ys).

getNumeroLigacoes(Cidade,Count) :- findall(Cidade,ligadas(Cidade,_),L),
								   length(L,Count).      



naoCaminho(Origem, [], Adj, [Origem|Adj]).
naoCaminho(Origem, [Primeiro|Caminho], Ligadas, Final) :- ligadas(Origem, Primeiro) -> naoCaminho(Primeiro, Caminho, [Origem|Ligadas], Final);
																						  naoCaminho(Origem, Caminho, Ligadas, Final).

ordenarC([(Cid, Ligacao)],[(Cid, Ligacao)]).
ordenarC([(Cid, Ligacao)|T], S) :- ordenarC(T, R), addOrdenaC((Cid,Ligacao),R, S).

addOrdenaC((Cid,Ligacao),[], S) :- S = [(Cid,Ligacao)].
addOrdenaC((Cid,Ligacao),[(X,Y)|T],S) :- Y >= Ligacao -> S = [(Cid,Ligacao),(X,Y)|T]; addOrdenaC((Cid,Ligacao),T,R), S = [(X,Y)|R].
  					     
                          


firstPar([(X,Y)|Z], X).



inverteCaminho(Xs, Ys):-
    reverse(Xs, [], Ys).


reverse([],Z,Z).
reverse([H|T],Z,Acc) :- reverse(T,[H|Z],Acc).

maximo([(P,X)],(P,X)).
maximo([(Px,X)|L],(Py,Y)):- maximo(L,(Py,Y)), X<Y. 
maximo([(Px,X)|L],(Px,X)):- maximo(L,(Py,Y)), X>=Y.

