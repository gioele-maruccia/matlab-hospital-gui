function [ ret ] = voce(saytext, voice, rate, volume, pitch, language)
    if nargin < 1
        error('You must provide the text string to speak!');
    end

% Make saytext cell array of characters:
if ~isa(saytext,'cell')
    saytext = {saytext};
end

    cmd = 'say ';

    if nargin >= 2 && ~isempty(voice)
        cmd = [cmd sprintf('-v ''%s'' ', voice)];
    end

    if nargin >= 3 && ~isempty(rate)
        cmd = [cmd sprintf('-r %i ', rate)];
    end

    for k=1:length(saytext)
        % Build command string for speech output and do a system() call:
        ret = system(sprintf('%s ''%s''', cmd, saytext{k}));
    end
