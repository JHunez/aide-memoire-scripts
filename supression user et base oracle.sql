#Cette requete oracle permet de pr�parer une base � la reprise de donn�es client.
#Elle se lance connect� � une base oracle via sqlplus par exemple.

#on drop l'user admindb et les sch�mas dont il est propri�taire. 
#on le recr�e et le rend admin du sch�ma. 
#l'import des donn�es client se fera via un autre script.

drop user admindb cascade;
create user admindb identified by rhcs ;
alter user admindb default tablespace  rhcsdat temporary tablespace rhcstmp ;
grant dba to admindb ;