% aggiornaAccessi(<UsernameUtente>), aggiorna il registro accessi annotando
% data e ora di accesso dell'utente fornito in imput
function [] = aggiornaAccessi(username)
    % aggiorno il registro accessi inserendovi CF, data e ora
    fid = fopen( 'accessi.txt', 'a' );
    fprintf( fid, '\n%s %s', username, datestr( clock, 0 ) );
    % chiudo il registro accessi
    fclose( fid );
end