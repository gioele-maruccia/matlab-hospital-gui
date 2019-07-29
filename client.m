% CLIENT si connette al server e legge il messaggio
% Uso - messaggio = client(host, portaa, numeroTentativi)
function message = client(host, porta, numeroTentativi)
    import java.net.Socket
    import java.io.*
    if (nargin < 3)
        % numero tentativi, inserire -1 per infinito
        numeroTentativi = 20; 
    end
    retry        = 0;
    input_socket = [];
    message      = [];
    while true
        retry = retry + 1;
        if ((numeroTentativi > 0) && (retry > numeroTentativi))
            fprintf(1, 'Too many retries\n');
            break;
        end
        try
            fprintf(1, 'Riprovo %d connettendomi a %s:%d\n', ...
                    retry, host, porta);

            % uscita se è impossibile collegarsi alla porta
            input_socket = Socket(host, porta);

            % prelevo un dato bufferizzato in imput dallo stream dal socket
            input_stream   = input_socket.getInputStream;
            d_input_stream = DataInputStream(input_stream);
            fprintf(1, 'Connesso al server\n');

            % lettura data dal socket- breve attesa di mezzo secondo
            pause(0.5);
            bytes_available = input_stream.available;
            fprintf(1, 'sto leggendo %d bytes\n', bytes_available);
            
            message = zeros(1, bytes_available, 'uint8');
            for i = 1:bytes_available
                message(i) = d_input_stream.readByte;
            end
            
            message = char(message);
            % pulizia/chiusura socket
            input_socket.close;
            break;
            catch
            if ~isempty(input_socket)
                input_socket.close;
            end
            % pausa prima di un altro tentativo
            pause(1);
        end
    end
end