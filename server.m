% SERVER
% Scrivo un messaggio alla porta specificata
% Uso - server(messaggio, portaOutput, numeroTentativi)
function server(messaggio, portaOutput, numeroTentativi)
    import java.net.ServerSocket
    import java.io.*
    % nargin: argomenti di ingresso e di uscita che un utente ha in
    % dotazione
    if (nargin < 3)
        % numero tentativi, inserire -1 per infinito
        numeroTentativi = 20; 
    end
    retry = 0;
    server_socket  = [];
    output_socket  = [];
    while true
        retry = retry+1;
        try
            if ((numeroTentativi > 0) && (retry > numeroTentativi))
                fprintf(1, 'Too many retries\n');
                break;
            end
            fprintf(1, ['Tentativo %d aspettando connessione da parte del CLIENT ' ...
                        'host alla porta : %d\n'], retry, portaOutput);
            % attendere un secondo affinchè il client si connetta al socket server
            server_socket = ServerSocket(portaOutput);
            server_socket.setSoTimeout(1000);
            output_socket = server_socket.accept;
            fprintf(1, 'CLIENT connesso\n');
            outputStream   = output_socket.getOutputStream;
            d_output_stream = DataOutputStream(outputStream);

            % stampo dati su DataOutputStream
            % converto in stream/flusso di dati
            fprintf(1, 'Writing %d bytes\n', length(messaggio))
            d_output_stream.writeBytes(char(messaggio));
            d_output_stream.flush;
            
            % pulizia socket
            server_socket.close;
            output_socket.close;
            break;
        catch
            if ~isempty(server_socket)
                server_socket.close
            end

            if ~isempty(output_socket)
                output_socket.close
            end

            % pausa di un secondo prima di fare un altro tentavivo
            pause(1);
        end
    end
end