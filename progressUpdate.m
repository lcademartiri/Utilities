function progressUpdate(iter, total, tStart, updateFreq, metrics)
    % iter: Current iteration (int)
    % total: Total iterations (int)
    % tStart: The tic start time (from tStart = tic)
    % metrics: A struct where field names are labels and values are numbers
    %          e.g., struct('SNR', 5.2, 'Gain', 0.01)
	
	persistent prevMsgLen;
    if isempty(prevMsgLen), prevMsgLen = 0; end
    if iter <= 1
        prevMsgLen = 0; 
    end

    if mod(iter, updateFreq) ~= 0 && iter ~= total, return; end
    if iter <= 0, return; end

    elapsed = toc(tStart);
    avgTime = elapsed / iter;
    eta     = avgTime * (total - iter);
    
    formatTime = @(s) sprintf('%02d:%02d:%02d', ...
        floor(s/3600), floor(mod(s,3600)/60), floor(mod(s,60)));
    
    elapsedStr = formatTime(elapsed);
    if isinf(eta) || isnan(eta), etaStr = '--:--:--';
    else, etaStr = formatTime(eta); end

    % --- FIXED METRICS LOGIC ---
    metStr = '';
    if nargin > 4 && isstruct(metrics)
        fns = fieldnames(metrics);
        for i = 1:numel(fns)
            val = metrics.(fns{i});
            % Check if value is text or number
            if ischar(val) || isstring(val)
                metStr = [metStr, sprintf(' | %s: %s', fns{i}, val)];
            else
                metStr = [metStr, sprintf(' | %s: %.3g', fns{i}, val)];
            end
        end
    end

    percent = (iter/total) * 100;
    progressLine = sprintf('Progress: [%-20s] %5.1f%% | Elapsed: %s | ETA: %s%s', ...
        repmat('=', 1, floor(percent/5)), percent, elapsedStr, etaStr, metStr);

    % Overwrite and Print
    fprintf(repmat('\b', 1, prevMsgLen));
    fprintf('%s', progressLine);
    prevMsgLen = length(progressLine);

    if iter >= total
        %fprintf('\n>> Done. Total Time: %s\n', elapsedStr);
		fprintf('\n', elapsedStr);
        prevMsgLen = 0;
    end
end