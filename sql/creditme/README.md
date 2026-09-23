# CreditMe / Lisa PostgreSQL

Ce répertoire contient un schéma de hackathon dérivé du dictionnaire fixed-width
`Sopra Banking Software 22-JAN-2021 – DOSSIER` fourni localement. Le dictionnaire
décrit des formats, pas des données métier réelles.

## Fichiers

- `01_schema.sql` : schéma `creditme`, catalogue exhaustif des
  enregistrements/champs (positions, niveaux, pictures, descriptions), staging
  `raw_record_payload` et projection prudente `dossier`.
- `02_demo_seed.sql` : une charge de démonstration manifestement fictive.
- `03_realistic_synthetic_seed.sql` : 12 dossiers de prêt synthétiques,
  crédibles pour une démonstration, ainsi que quelques payloads raw associés.

## Exécution sur Azure PostgreSQL

1. Utiliser `psql` installé localement ou dans Azure Cloud Shell; récupérer le
   nom d’hôte, la base et l’utilisateur depuis Azure, sans les écrire dans le
   dépôt.
2. Fournir le secret via le mécanisme local de `psql` (invite interactive,
   fichier `.pgpass` protégé ou variable d’environnement temporaire), jamais
   dans une commande versionnée.
3. Exécuter :

```powershell
psql "host=<serveur>.postgres.database.azure.com port=5432 dbname=<base> user=<utilisateur> sslmode=require" -f sql/creditme/01_schema.sql
psql "host=<serveur>.postgres.database.azure.com port=5432 dbname=<base> user=<utilisateur> sslmode=require" -f sql/creditme/02_demo_seed.sql
```

Le catalogue conserve les champs non modélisés dans
`creditme.raw_record_payload`; seules les colonnes de `creditme.dossier`
directement identifiables sont projetées.

Les données du fichier `03_realistic_synthetic_seed.sql` sont entièrement
fictives. Elles ressemblent à des dossiers de crédit réalistes, mais ne
représentent aucun client ni compte réel.
