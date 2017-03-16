CREATE TABLE T_TYPE (TYP_CODE char(8) not null primary key,

					 TYP_LIBELLE varchar(32) not null);

CREATE TABLE T_TITRE ( TIT_CODE char (8) not null primary key,

                      TIT_LIBELLE varchar (32) not null);

CREATE TABLE T_TELEPHONE (TEL_ID integer(12) not null primary key,

						  TEL_NUMERO varchar(20) not null,

						  TEL_LOCALISATION varchar(64),

						  CLI_ID integer(12) not null,

						  TYP_CODE char(8) not null,

						  foreign key (CLI_ID) references T_CLIENT

                          on delete cascade on update cascade

                          foreign key (TYP_CODE) references TYPE

                          on delete cascade on update cascade);

CREATE TABLE T_TARIF (TRF_DATE_DEBUT date not null primary key,

					  TRF_TAUX_TAXES real(8) not null,

					  TRF_PETIT_DEJEUNE decimal(8) not null);

CREATE TABLE T_PLANNING (PLN_JOUR date not null primary key);

CREATE TABLE T_MODE_PAIEMENT (PMT_CODE char(8) not null primary key,

							  PMT_LIBELLE varchar(64) not null);

 CREATE TABLE T_LIGNE_FACTURE (LIF_ID integer(12) not null primary key,

							  LIF_QTE real(8) not null,

							  LIF_REMISE_POURCENT real(8),

							  LIF_REMISE_MONTANT decimal(8),

							  LIF__MONTANT decimal(8) not null,

							  LIF_TAUX_TVA real(8) not null default '19,6',

							  FAC_ID integer(12) not null,

							  foreign key (FAC_ID) references T_FACTURE

                          		on delete cascade on update cascade);

CREATE TABLE T_FACTURE (FAC_ID integer(12) not null primary key,

						FAC_DATE date not null,

                        PMT_CODE char(8) not null,

                        FAC_PMT_DATE date not null,

						CLI_ID integer(12) not null,

						foreign key (CLI_ID) references T_CLIENT

                          on delete cascade on update cascade);

CREATE TABLE T_EMAIL (EML_ID integer(12) not null primary key,

					  EML_ADRESSE varchar(100) not null,

					  EML_LOCALISATION varchar(64),

					  CLI_ID integer(12) not null,

					  foreign key (CLI_ID) references T_CLIENT

                          on delete cascade on update cascade);

CREATE TABLE T_CLIENT ( CLI_ID integer (12) not null primary key,

                      CLI_NOM char (32) not null,

                      CLI_PRENOM varchar (25) not null,

                      CLI_ENSEIGNE varchar (100) null,

                      TIT_CODE varchar(8) not null,

                      foreign key (TIT_CODE) references T_TITRE

                          on delete cascade on update cascade);

CREATE TABLE T_CHAMBRE (CHB_ID integer(12) not null primary key,

						CHB_NUMERO smallint(8) not null,

						CHB_ETAGE char(3) not null,

						CHB_BAIN smallint(1) not null,         

						CHB_DOUCHE smallint(1) not null,

						CHB_WC smallint(1) not null,

						CHB_COUCHAGE smallint(1) not null,

						CHB_POSTE_TEL char(3) not null)

CREATE TABLE T_ADRESSE (ADR_ID integer (12) not null primary key,
					  
					  ADR_LIGNE1 varchar(32) not null,

					  ADR_LIGNE2 varchar(32) ,

					  ADR_LIGNE3 varchar(32) ,

					  ADR_LIGNE4 varchar(32) ,

					  ADR_CP char(6) not null,

					  ADR_VILLE char(32) not null,

					  CLI_ID integer(12) not null,

					  foreign key (CLI_ID) references T_CLIENT

                          on delete cascade on update cascade);

CREATE TABLE TJ_TRF_CHB (CHB_ID integer(12) not null,

						 TRF_DATE_DEBUT date not null,

                                                  TRF_CHB_PRIX numeric(8,2) not null,

						 primary key(CHB_ID,TRF_DATE_DEBUT));

CREATE TABLE TJ_CHB_PLN_CLI (CHB_ID integer(12) not null,
							
							 CLI_ID integer(12) not null,

							 PLN_JOUR date not null,

							 CHB_PLN_CLI_NB_PERS smallint(8) not null,

							 CHB_PLN_CLI_RESERVE smallint(1) not null,

							 CHB_PLN_CLI_OCCUPE smallint(1) not null,

							 primary key (CHB_ID,CLI_ID,PLN_JOUR),

							 foreign key (CHB_ID) references T_CHAMBRE

                          		on delete cascade on update cascade

                          	foreign key (CLI_ID) references T_CLIENT

                          		on delete cascade on update cascade

                          	foreign key (PLN_JOUR) references T_PLANNING

                          		on delete cascade on update cascade);