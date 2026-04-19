ajout exeption lors de la creation de reservation :
    - s il y a deja une reservation d un autre service et autre media a la meme date et a la meme heure 
    - s il y a deja une reservation avec la  meme service et la meme media alros il faut decaler la nouvelle reservation au lendemain : par exemple : il y a une reservation 10,11 ,12 a 11h et qu on fait la une reservation avec la meme services et le meme media avec date 11 alors la reservation se decale le 12 mais or il y a la meme aussi le 12 alors on le decale encore donc le 13

Prendre en compte la duree . Par exemple heure de debut etant 11h la duree est de 15min alors il faut considerer cette intervalle comme occupe. 