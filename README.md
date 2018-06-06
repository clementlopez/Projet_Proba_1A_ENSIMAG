# Projet_Proba_1A_ENSIMAG

Ce projet a été écrit en langage R. Le code n'est pas optimisé mais a été pensé et commenté de manière à être facilement compris et pris en main.

## Lancement de la simulation

La simulation de la file d'attente se lance avec la commande : `function (lambda, mu, N, p1, p2, t)`

## Notations utilisées dans le code

- `lambda` : L'intensité des requêtes
- `mu` : Tel que `1/mu` représente le temps de service moyen d'une requête
- `N` : Nombre maximal de requêtes pouvant être dans la file d'attente (en incluant celle en cours de traitement)
- `p1 et p2` : Les probabilités que la requête reçue soit de priorité respectivement prioritaire et normale (la probabilité que la requête soit de priorité lente est implicite : p3 = 1 - p1 - p2
- `t` : Temps voulu de simulation
- `tps` : Temps écoulé de simulation
- `reqQ, reqPrio, reqNorm, Lent` : Respectivement nombre total de requêtes dans la file d'attente, nombre de requêtes prioritaires, nombre de requêtes normales et nombre de requêtes lentes dans la file d'attente
- `cmpQ, cmpPrio, cmpNorm, cmpLent` : Respectivement compteur du nombre total de requêtes reçues, compteur du nombre de requêtes prioritaires, compteur du nombre de requêtes normales et compteur du nombre de requêtes lentes reçues
- `termQ, termPrio, termNorm, termLent` : Respectivement nombre total de requêtes terminées, nombre de requêtes prioritaires, nombre de requêtes normales et nombre de requêtes lentes terminées
- `anQ, anPrio, anNorm, anLent` : Respectivement nombre total de requêtes annulées, nombre de requêtes prioritaires, nombre de requêtes normales et nombre de requêtes lentes annulées
- `Tsuiv, Ssuiv` : Respectivement durée avant une nouvelle arrivée et durée avant un service fini (départ d'une requête)
- `prioReqActu` : Priorité de la requête actuellement traitée
- `nbOp et somReq` : Respectivement le nombre d'opérations (arrivées ou départs) depuis le début de la simulation et la somme des requêtes dans la file après chaque opération. Ces deux variables seront utilisées pour calculer le nombre moyen de requêtes dans la simulation `somReq/nbOp`
- `xT, yR, yRP, yRN, yRL` : Utilisées pour effectuer le plot, ces variables représentent respectivement l'axe du temps, l'axe du nombre total de requetes à un instant t, l'axe du nombre de requetes prioritaires/normales/lentes à un instant t
- `prio` : Variable permettant de définir le degré de priorité de la nouvelle requête (1 si prioritaire, 2 si normale, 3 si lente)
