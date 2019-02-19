#Cette requete oracle permet de préparer une base à la reprise de données client.
#Elle se lance connecté à une base oracle via sqlplus par exemple.

#on drop l'user admindb et les schémas dont il est propriétaire. 
#on le recrée et le rend admin du schéma. 
#l'import des données client se fera via un autre script.

drop user admindb cascade;
create user admindb identified by rhcs ;
alter user admindb default tablespace  rhcsdat temporary tablespace rhcstmp ;
grant dba to admindb ;