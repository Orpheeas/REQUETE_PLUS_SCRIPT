--Nombre de clients

SELECT count(CLI_ID)
FROM T_CLIENT;

--Les clients triés sur le titre et le nom

SELECT *
FROM T_CLIENT
ORDER by TIT_CODE, CLI_NOM;

--Les clients triés sur le libellé du titre et le nom

SELECT *
FROM T_CLIENT,T_TITRE
ORDER by TIT_LIBELLE, CLI_NOM;

--Les clients commençant par 'B'

SELECT *
FROM T_CLIENT
WHERE CLI_NOM like "B%";

--Les clients homonymes

SELECT  *
FROM T_CLIENT A
WHERE EXISTS (SELECT *
              FROM T_CLIENT B
              WHERE (A.CLI_ID <> B.CLI_ID)
              AND (A.CLI_NOM=B.CLI_NOM)
);

--Nombre de titres différents

SELECT distinct count(*)
FROM T_TITRE;

--Nombre d'enseignes

SELECT count(CLI_ENSEIGNE)
FROM T_CLIENT;

--Les clients qui représentent une enseigne 

SELECT *
FROM T_CLIENT
WHERE CLI_ENSEIGNE is not null;

--Les clients qui représentent une enseigne de transports

SELECT *
FROM T_CLIENT
WHERE upper(CLI_ENSEIGNE) like upper("%TRANSPORT%");

--Nombre d'hommes,Nombres de femmes, de demoiselles, Nombres de sociétés

SELECT
(SELECT count(*) FROM T_CLIENT WHERE TIT_CODE="M.") as HOMME,
(SELECT count(*) FROM T_CLIENT WHERE TIT_CODE="Mme.") as FEMME,
(SELECT count(*) FROM T_CLIENT WHERE TIT_CODE="Melle.") as DEMOISELLE,
(SELECT count(*) FROM T_CLIENT WHERE CLI_ENSEIGNE is not null) as REPRESENTANT;

--Nombre d''emails

SELECT count(*)
FROM T_EMAIL;

--Client sans email 

SELECT CLI_NOM
FROM T_CLIENT
WHERE CLI_NOM not in (
                                    SELECT CLI_NOM
                                    FROM T_CLIENT,T_EMAIL
                                    WHERE (T_CLIENT.CLI_ID=T_EMAIL.CLI_ID)); 

--Clients sans téléphone 

SELECT distinct CLI_NOM
FROM T_CLIENT
WHERE CLI_NOM not in (
					  SELECT distinct CLI_NOM
                      FROM T_CLIENT, T_TELEPHONE
                      WHERE T_CLIENT.CLI_ID=T_TELEPHONE.CLI_ID);



--Les phones des clients
 
SELECT TEL_NUMERO, CLI_ID          //Cli_Id est présent pour savoir à quel num est associé quel client
FROM T_TELEPHONE;

--Répartition des phones par catégorie

SELECT   TYP_CODE,
         COUNT(* )
FROM     T_TELEPHONE
GROUP BY TYP_CODE;

--Les clients ayant plusieurs téléphones

_


--Clients sans adresse:

SELECT distinct CLI_ID
FROM T_CLIENT
WHERE CLI_ID not in (
					  SELECT T_CLIENT.CLI_ID
                      FROM T_CLIENT, T_ADRESSE
                      WHERE T_CLIENT.CLI_ID=T_ADRESSE.CLI_ID);

--Clients sans adresse mais au moins avec mail ou phone 

SELECT distinct CLI_ID
FROM T_CLIENT
WHERE CLI_ID not in (
					  SELECT T_CLIENT.CLI_ID
                                          FROM T_CLIENT, T_ADRESSE
                                          WHERE T_CLIENT.CLI_ID=T_ADRESSE.CLI_ID)
                AND (
                                   (
                                       SELECT T_EMAIL.CLI_ID
                                       FROM T_EMAIL) 
				OR(
                                       SELECT T_TELEPHONE.CLI_ID
                                       FROM T_TELEPHONE));



--Dernier tarif renseigné

SELECT MAX(TRF_DATE_DEBUT)
FROM T_TARIF;

--Tarif débutant le plus tôt 

SELECT MIN(TRF_DATE_DEBUT)
FROM T_TARIF;

--Différentes Années des tarifs

--

--Nombre de chambres de l'hotel 

SELECT count(CHB_ID)
FROM T_CHAMBRE;

--Nombre de chambres par étage

SELECT   CHB_ETAGE,
               COUNT(*)
FROM T_CHAMBRE
GROUP BY CHB_ETAGE;

--Chambres sans telephone

SELECT  CHB_POSTE_TEL
FROM T_CHAMBRE
WHERE CHB_POSTE_TEL is null;

--Existence d'une chambre n°13 ?

SELECT  CHB_ID
FROM T_CHAMBRE
WHERE CHB_NUMERO=13;

--Chambres avec sdb

SELECT  CHB_ID
FROM T_CHAMBRE
WHERE CHB_BAIN !=0

--Chambres avec douche

SELECT  CHB_ID
FROM T_CHAMBRE
WHERE CHB_DOUCHE !=0

--Chambres avec WC

SELECT  CHB_ID
FROM T_CHAMBRE
WHERE CHB_WC !=0

--Chambres sans WC séparés

SELECT  CHB_ID
FROM T_CHAMBRE
WHERE CHB_WC =0;

--Quels sont les étages qui ont des chambres sans WC séparés ?

SELECT CHB_ETAGE
FROM T_CHAMBRE
WHERE CHB_WC=0;

--Nombre d'équipements sanitaires par chambre trié par ce nombre d'équipement croissant

SELECT (CHB_DOUCHE+CHB_BAIN+CHB_WC) as Equip, CHB_ID
FROM T_CHAMBRE
ORDER BY Equip;

--Chambres les plus équipées et leur capacité

SELECT (CHB_DOUCHE+CHB_BAIN+CHB_WC) as Equip, CHB_ID, CHB_COUCHAGE  //Where Equip=3 car ce sont les chb les plus equipées
FROM T_CHAMBRE
WHERE Equip=3
ORDER BY Equip;

--Repartition des chambres en fonction du nombre d'équipements et de leur capacité

SELECT (CHB_DOUCHE+CHB_BAIN+CHB_WC) as Equip,  CHB_COUCHAGE, count(*)
FROM T_CHAMBRE
GROUP BY CHB_COUCHAGE;

--Nombre de clients ayant utilisé une chambre

SELECT T_CLIENT.CLI_ID
FROM T_CLIENT, T_FACTURE
WHERE (SELECT T_FACTURE.CLI_ID
              FROM T_CLIENT, T_FACTURE
              WHERE T_CLIENT.CLI_ID=T_FACTURE.CLI_ID);

--Clients n'ayant jamais utilisé une chambre (sans facture)

SELECT distinct T_CLIENT.CLI_ID
FROM T_CLIENT, T_FACTURE
WHERE  not (SELECT T_FACTURE.CLI_ID
              FROM T_CLIENT, T_FACTURE
              WHERE T_CLIENT.CLI_ID=T_FACTURE.CLI_ID);

--Nom et prénom des clients qui ont une facture

SELECT CLI_NOM, CLI_PRENOM
FROM T_CLIENT, T_FACTURE
WHERE (SELECT T_FACTURE.CLI_ID
              FROM T_CLIENT, T_FACTURE
              WHERE T_CLIENT.CLI_ID=T_FACTURE.CLI_ID);

--Nom, prénom, telephone des clients qui ont une facture

SELECT CLI_NOM, CLI_PRENOM,TEL_NUMERO
FROM T_CLIENT, T_FACTURE,T_TELEPHONE
WHERE (SELECT T_FACTURE.CLI_ID
              FROM T_CLIENT, T_FACTURE
              WHERE T_CLIENT.CLI_ID=T_FACTURE.CLI_ID);

--Attention si email car pas obligatoire : jointure externe

--Adresse où envoyer factures aux clients

SELECT ADR_LIGNE1,ADR_LIGNE2,ADR_LIGNE3,ADR_LIGNE4
FROM T_ADRESSE, T_FACTURE
WHERE (SELECT T_FACTURE.CLI_ID
              FROM T_ADRESSE, T_FACTURE
              WHERE T_ADRESSE.CLI_ID=T_FACTURE.CLI_ID);

--Répartition des factures par mode de paiement (libellé)

--Répartition des factures par mode de paiement 

--Différence entre ces 2 requêtes ? 

--Factures sans mode de paiement 

--Repartition des factures par Années

--Repartition des clients par ville

--Montant TTC de chaque ligne de facture (avec remises)

--Classement du montant total TTC (avec remises) des factures

--Tarif moyen des chambres par années croissantes

--Tarif moyen des chambres par étage et années croissantes

--Chambre la plus cher et en quelle année

--Chambre la plus cher par année 

--Clasement décroissant des réservation des chambres 

--Classement décroissant des meilleurs clients par nombre de réservations

--Classement des meilleurs clients par le montant total des factures

--Factures payées le jour de leur édition

--Facture dates et Délai entre date de paiement et date d'édition de la facture