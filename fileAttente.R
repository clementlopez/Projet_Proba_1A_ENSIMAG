fileAttente <- function (lambda, mu, N, p1, p2, t){


	print('Vérification des paramêtres: .')
  # On vérifie les probas
  stopifnot(0<=p1 && 0<=p2 && (p1+p2)<=1)
	print('.')
	# l'intensité des requêtes doit être > 0
	stopifnot(lambda>0)
	print('.')
	# le taux de traitement doit être > 0
	stopifnot(mu>0)
	print('.')
	# le nombre de places dans la file doit être >= 1
	stopifnot(N>=1)
	print('.')
	# Le temps de simulation doit être > 0
	stopifnot(t>0)
	# Lambda et mu doivent être différents car
	# sinon on fait une division par 0 lors du calcul du nombre moyen de requêtes (théorique)
	stopifnot(lambda!=mu)


	print('Démarrage de la simulation')
	#Nombre de requêtes dans la queue
	reqQ <- 0
	#Nombre de requêtes prioritaires dans la queue
	reqPrio <- 0
	#Nombre de requêtes normales dans la queue
	reqNorm <- 0
	#Nombre de requêtes lentes dans la queue
	reqLent <- 0
	
	#Compteur du nombre total de requêtes reçues
	cmpQ <- 0
	#Compteur du nombre total de requêtes prioritaires reçues
	cmpPrio <- 0
	#Compteur du nombre total de requêtes normales reçues
	cmpNorm <- 0
	#Compteur du nombre total de requêtes lentes reçues
	cmpLent <- 0
	
	#Nombre de requêtes terminées
	termQ <- 0
	#Nombre de requêtes prioritaires terminées
	termPrio <- 0
	#Nombre de requêtes normales terminées
	termNorm <- 0
	#Nombre de requêtes lentes terminées
	termLent <- 0
	
	#Nombre de requêtes annulées
	anQ <- 0
	#Nombre de requêtes prioritaires annulées
	anPrio <- 0
	#Nombre de requêtes normales annulées
	anNorm <- 0
	#Nombre de requêtes lentes annulées
	anLent <- 0
	
	#Tsuiv est la durée avant une nouvelle arrivée
	Tsuiv <- rexp(1, lambda)
	#Suiv est la durée avant un service fini (départ d'une requête)
	Ssuiv <- 0
	
	# Priorité de la requête actuellement traitée
	# 1 pour prioritaire, 2 pour normale, 3 pour lente
	# initialisation à 0 (aucune requête actuellement traitée)
	prioReqActu <- 0
	
	#Nombre d'opérations (arrivées ou départs)
	nbOp <- 0
	#Somme des requêtes dans la file après chaque opération (pour la moyenne)
	somReq <- 0
	
	# initialisation du tps à 0
	tps <- 0
	
	# On prépare le plot
	# Axe du temps
	xT <- 0
	# Axe du nombre total de requetes à un instant t
	yR <- 0
	# Axe du nombre de requetes prioritaires à un instant t
	yRP <- 0
	# Axe du nombre de requetes normales à un instant t
	yRN <- 0
	# Axe du nombre de requetes lentes à un instant t
	yRL <- 0
  
	print('Lancement de la file d\'attente')
	# Tant qu'on est dans la plage temporelle de la simulation
	while(tps<t){
		# Si la file est vide ou qu'une arrivée arrive avant un départ
		if(reqQ==0|| Tsuiv < Ssuiv){
		  #On compte une arrivée de plus
		  cmpQ = cmpQ + 1
			#On défini le degré de priorité de la nouvelle requête
			temp <- runif(1)
			if (temp < p1){
				#Si prioritaire
				prio <- 1
				cmpPrio = cmpPrio + 1
			}
			else if (temp < p1+p2){
				#Si normale
				prio <- 2
				cmpNorm = cmpNorm + 1
			}
			else {
				#Si lente
				prio <- 3
				cmpLent = cmpLent + 1
			}
			
			#on avance le temps
			tps = tps + Tsuiv
			# Si la file est vide
			if (reqQ==0){
				# On calcule le prochain départ
				Ssuiv = rexp(1, mu)
				# La requête devient en cours de traitement car c'est la seule
				prioReqActu = prio
			}
			else{
				# Sinon on réduit le temps pour le prochain départ
				Ssuiv = Ssuiv - Tsuiv
			}
			# On calcule la prochaine arrivée
			Tsuiv = rexp(1, lambda)
			
			# Si la file est déjé pleine
			if(reqQ >= N){
				#Si la nouvelle requête est de priorité lente on ne la prend pas
				if (prio == 3){
					print('[WARNING] annulation d\'une requête lente')
					anLent = anLent +1
					anQ = anQ +1
				}
				#Si la nouvelle requête est de priorité moyenne
				else if (prio == 2){
					#S'il n'y a pas de requête lente à remplacer
					# Ou s'il n'y a qu'une requête lente mais qu'elle est en cours de traitement
					if(reqLent == 0 || (reqLent ==1 && prioReqActu==3)){
						print('[WARNING] annulation d\'une requête normale')
						anNorm = anNorm +1
						anQ = anQ +1
					}
					else{
						#Sinon la requête prend la place d'une requête lente (qui est alors annulée)
						print('[WARNING] annulation d\'une requête lente')
						anLent = anLent + 1
						anQ = anQ + 1
						reqLent = reqLent - 1
						reqNorm = reqNorm + 1
					}
				}
				#Si la nouvelle requête est de priorité prioritaire
				else{
					#S'il n'y a pas de requête lente à remplacer
					# Ou s'il n'y a qu'une requête lente mais qu'elle est en cours de traitement
					if(reqLent == 0 || (reqLent ==1 && prioReqActu==3)){
						#S'il n'y a pas de requête normale à remplacer
						# Ou s'il n'y a qu'une requête normale mais qu'elle est en cours de traitement
						if(reqNorm == 0 || (reqNorm ==1 && prioReqActu==2)){
							#On doit donc annuler la requête prioritaire reçues
							print('[WARNING] annulation d\'une requête prioritaire')
							anQ = anQ + 1
							anPrio = anPrio + 1
						}
						else{
							#Sinon la requête prend la place d'une requête normale (qui est alors annulée)
							print('[WARNING] annulation d\'une requête normale')
							anNorm = anNorm + 1
							anQ = anQ + 1
							reqPrio = reqPrio + 1
							reqNorm = reqNorm - 1
						}
						
					}
					else{
						#Sinon la requête prend la place d'une requête lente (qui est alors annulée)
						print('[WARNING] annulation d\'une requête lente')
						anLent = anLent + 1
						anQ = anQ + 1
						reqLent = reqLent - 1
						reqPrio = reqPrio + 1
					}
				}
				
			}
			else{
				# On compte la nouvelle arrivée
				reqQ = reqQ + 1
				# On compte e niveau de priorité
				if(prio==1){
					reqPrio = reqPrio + 1
				}
				else if (prio == 2){
					reqNorm = reqNorm + 1
				}
				else{
					reqLent = reqLent + 1
				}
			}
		}
		#Sinon on assiste à un départ
		else{
			#on avance le temps
			tps = tps + Ssuiv
			# On réduit le temps pour la prochaine arrivée
			Tsuiv = Tsuiv - Ssuiv
			# On calcule le prochain départ
			Ssuiv = rexp(1, mu)
			
			#On enleve une requête de la file
			reqQ = reqQ - 1
			#On augmente le nombre de requête terminées
			termQ = termQ + 1
			
			#On regarde la priorité de la requête qui était en cours de traitement
			if(prioReqActu==1){
				reqPrio = reqPrio - 1
				termPrio = termPrio + 1
			}
			else if(prioReqActu == 2){
				reqNorm = reqNorm - 1
				termNorm = termNorm + 1
			}
			else {
				reqLent = reqLent - 1
				termLent = termLent + 1
			}
			
			#On choisi la prochaine requête à traiter (en fonction de la priorité)
			if(reqPrio>0){
				prioReqActu = 1
			}
			else if(reqNorm>0){
				prioReqActu = 2
			}
			else if(reqLent>0){
				prioReqActu = 3
			}
			else{
				#Si on n'a plus aucune requête à traiter
				prioReqActu = 0
			}
			
		}
		somReq = somReq + reqQ
		nbOp = nbOp + 1
		
    # On ajoute les valeurs au plot
		xT = c(xT,tps)
		yR = c(yR,reqQ)
		yRP = c(yRP,reqPrio)
		yRN = c(yRN,reqNorm)
		yRL = c(yRL,reqLent)
	}
	
  # On prépare la légende du plot & on plotte
	
	plot(xT, yR, xlab="Temps", ylab="Nombre de requêtes", type="s", main="Simulation de file d'attente")
	legend("topleft",legend=c("Total","Prioritaires","Normales","Lentes"), col=c("black", "red","blue","green"),lty=c(1,1,1,1), ncol=1)
	lines(xT, yRP, col="red",type="s")
	lines(xT, yRN, col="blue",type="s")
	lines(xT, yRL, col="green",type="s")
	points(xT, yRP, col="red", pch=NA_integer_)
	points(xT, yRN, col="blue", pch=NA_integer_)
	points(xT, yRL, col="green", pch=NA_integer_)
	
	
	
	print('Résultats :')
	print('Nombre total de requêtes en queue :')
	print(reqQ)
	print('Nombre de requêtes prioritaires en queue:')
	print(reqPrio)
	print('Nombre de requêtes normales en queue:')
	print(reqNorm)
	print('Nombre de requêtes lentes en queue:')
	print(reqLent)
	
	print('Nombre total de requêtes reçues :')
	print(cmpQ)
	print('Nombre de requêtes prioritaires reçues:')
	print(cmpPrio)
	print('Nombre de requêtes normales reçues:')
	print(cmpNorm)
	print('Nombre de requêtes lentes reçues:')
	print(cmpLent)
	
	print('Nombre total de requêtes terminées :')
	print(termQ)
	print('Nombre de requêtes prioritaires terminées:')
	print(termPrio)
	print('Nombre de requêtes normales terminées:')
	print(termNorm)
	print('Nombre de requêtes lentes terminées:')
	print(termLent)
	
	print('Nombre total de requêtes annulées :')
	print(anQ)
	print('Nombre de requêtes prioritaires annulées:')
	print(anPrio)
	print('Nombre de requêtes normales annulées:')
	print(anNorm)
	print('Nombre de requêtes lentes annulées:')
	print(anLent)
	
	print('Nombre moyen de requêtes (dans la simulation) :')
	print(somReq/nbOp)
	print('Nombre moyen de requetes (dans la théorie) :')
	ro <- lambda/mu
	EspéranceXt <- (((1-(ro^(N-1))) / (1-ro)) - N*(ro^(N))) * (ro / (1-(ro^(N+1))))
	print(EspéranceXt)
	
	print('Taux de perte (dans la simulation) :')
	print(anQ/(cmpQ+anQ))
	print('Probabilité de perte (dans la théorie) :')
	print(((1-ro)/(1-ro^(N+1)))*ro^(N))
	
}

